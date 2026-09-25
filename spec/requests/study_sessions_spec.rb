require "rails_helper"

RSpec.describe "Study Sessions", type: :request do
  let!(:deck) { Deck.create!(name: "Spanish") }

  describe "GET /decks/:deck_id/study_session" do
    it "shows the question of a due card without the answer" do
      deck.cards.create!(question: "Hello", answer: "Hola")

      get deck_study_session_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello")
      expect(response.body).not_to include("Hola")
      expect(response.body).to include("Show Answer")
    end

    it "shows the answer and rating buttons when revealed" do
      deck.cards.create!(question: "Hello", answer: "Hola")

      get deck_study_session_path(deck, reveal: true)

      expect(response.body).to include("Hola")
      %w[Again Hard Good Easy].each do |label|
        expect(response.body).to include(label)
      end
    end

    it "includes cards due in the past" do
      deck.cards.create!(
        question: "Overdue",
        answer: "Atrasado",
        next_review_date: Date.current - 3.days
      )

      get deck_study_session_path(deck)

      expect(response.body).to include("Overdue")
    end

    it "does not show cards scheduled for the future" do
      deck.cards.create!(
        question: "Later",
        answer: "Luego",
        next_review_date: Date.current + 1.day
      )

      get deck_study_session_path(deck)

      expect(response.body).not_to include("Later")
      expect(response.body).to include("No cards are due for review")
    end

    it "does not show due cards from another deck" do
      other_deck = Deck.create!(name: "French")
      other_deck.cards.create!(question: "Bonjour", answer: "Hello")

      get deck_study_session_path(deck)

      expect(response.body).not_to include("Bonjour")
    end

    it "shows the number of cards due" do
      deck.cards.create!(question: "Hello", answer: "Hola")
      deck.cards.create!(question: "Goodbye", answer: "Adios")

      get deck_study_session_path(deck)

      expect(response.body).to include("2 cards due")
    end

    it "shows an empty-state message when the deck has no cards" do
      get deck_study_session_path(deck)

      expect(response.body).to include("does not have any cards to study")
    end

    it "returns not found for a missing deck" do
      get "/decks/999999/study_session"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /decks/:deck_id/study_session/review" do
    let!(:card) { deck.cards.create!(question: "Hello", answer: "Hola") }

    {
      "again" => { repetition: 0, interval: 1 },
      "hard" => { repetition: 1, interval: 1 },
      "good" => { repetition: 1, interval: 1 },
      "easy" => { repetition: 1, interval: 1 }
    }.each do |rating, expected|
      it "schedules the card with SM-2 when rated #{rating}" do
        post review_deck_study_session_path(deck),
             params: { card_id: card.id, rating: rating }

        card.reload
        expect(card.repetition).to eq(expected[:repetition])
        expect(card.interval).to eq(expected[:interval])
        expect(card.next_review_date).to eq(Date.current + 1.day)
        expect(response).to redirect_to(deck_study_session_path(deck))
      end
    end

    it "tells the learner when the card is due next" do
      post review_deck_study_session_path(deck),
           params: { card_id: card.id, rating: "good" }
      follow_redirect!

      expect(response.body).to include(
        "Next review of &quot;Hello&quot; is #{(Date.current + 1.day).to_fs(:review)} (in 1 day)."
      )
    end

    it "maps ratings to the expected ease factor changes" do
      post review_deck_study_session_path(deck),
           params: { card_id: card.id, rating: "easy" }

      expect(card.reload.ease_factor).to be > 2.5
    end

    it "removes the graded card from the queue and shows the next one" do
      deck.cards.create!(question: "Goodbye", answer: "Adios")

      post review_deck_study_session_path(deck),
           params: { card_id: card.id, rating: "good" }
      follow_redirect!

      flashcard = Nokogiri::HTML(response.body).at_css(".flashcard").text
      expect(flashcard).not_to include("Hello")
      expect(flashcard).to include("Goodbye")
      expect(response.body).to include("1 card due")
    end

    it "shows the no-cards-due message after the last card is graded" do
      post review_deck_study_session_path(deck),
           params: { card_id: card.id, rating: "good" }
      follow_redirect!

      expect(response.body).to include("No cards are due for review")
    end

    it "rejects an invalid rating without changing the card" do
      expect {
        post review_deck_study_session_path(deck),
             params: { card_id: card.id, rating: "perfect" }
      }.not_to change { card.reload.updated_at }

      follow_redirect!
      expect(response.body).to include("Please choose Again, Hard, Good, or Easy.")
    end

    it "does not grade a card that is not due" do
      card.update!(next_review_date: Date.current + 5.days)

      expect {
        post review_deck_study_session_path(deck),
             params: { card_id: card.id, rating: "good" }
      }.not_to change { card.reload.repetition }

      follow_redirect!
      expect(response.body).to include("That card is not due for review.")
    end

    it "does not grade a card from another deck" do
      other_deck = Deck.create!(name: "French")
      other_card = other_deck.cards.create!(question: "Bonjour", answer: "Hello")

      post review_deck_study_session_path(deck),
           params: { card_id: other_card.id, rating: "good" }

      expect(other_card.reload.repetition).to eq(0)
      expect(other_card.next_review_date).to eq(Date.current)
    end
  end
end
