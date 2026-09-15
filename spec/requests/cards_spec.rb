require "rails_helper"

RSpec.describe "Cards", type: :request do
  let!(:deck) { Deck.create!(name: "Spanish") }

  describe "GET /decks/:deck_id/cards" do
    it "returns a successful response" do
      get deck_cards_path(deck)

      expect(response).to have_http_status(:ok)
    end

    it "displays cards belonging to the selected deck" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      get deck_cards_path(deck)

      expect(response.body).to include(card.question)
      expect(response.body).to include(card.answer)
    end

    it "does not display cards from another deck" do
      other_deck = Deck.create!(name: "French")

      other_card = other_deck.cards.create!(
        question: "Bonjour",
        answer: "Hello"
      )

      get deck_cards_path(deck)

      expect(response.body).not_to include(other_card.question)
      expect(response.body).not_to include(other_card.answer)
    end

    it "returns successfully when the deck has no cards" do
      get deck_cards_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Cards")
    end
  end

  describe "GET /decks/:deck_id/cards/new" do
    it "shows the new card form" do
      get new_deck_card_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Question")
      expect(response.body).to include("Answer")
    end
  end

  describe "GET /decks/:deck_id/cards/:id" do
    it "shows the requested card" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      get deck_card_path(deck, card)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(card.question)
      expect(response.body).to include(card.answer)
    end
  end

  describe "GET /decks/:deck_id/cards/:id/edit" do
    it "shows the card edit form with existing information" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      get edit_deck_card_path(deck, card)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello")
      expect(response.body).to include("Hola")
      expect(response.body).to include("Question")
      expect(response.body).to include("Answer")
    end
  end

  describe "POST /decks/:deck_id/cards" do
    it "creates a card with valid input" do
      expect do
        post deck_cards_path(deck), params: {
          card: {
            question: "Hello",
            answer: "Hola"
          }
        }
      end.to change(Card, :count).by(1)

      expect(response).to redirect_to(deck_path(deck))
      expect(Card.last.deck).to eq(deck)
    end

    it "does not create a card with a blank question" do
      expect do
        post deck_cards_path(deck), params: {
          card: {
            question: "",
            answer: "Hola"
          }
        }
      end.not_to change(Card, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not create a card with a blank answer" do
      expect do
        post deck_cards_path(deck), params: {
          card: {
            question: "Hello",
            answer: ""
          }
        }
      end.not_to change(Card, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /decks/:deck_id/cards/:id" do
    let!(:card) do
      deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )
    end

    it "updates a card with valid input" do
      patch deck_card_path(deck, card), params: {
        card: {
          question: "Goodbye",
          answer: "Adios"
        }
      }

      expect(response).to redirect_to(deck_path(deck))
      expect(card.reload.question).to eq("Goodbye")
      expect(card.reload.answer).to eq("Adios")
    end

    it "does not update a card with invalid input" do
      patch deck_card_path(deck, card), params: {
        card: {
          question: "",
          answer: ""
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(card.reload.question).to eq("Hello")
      expect(card.reload.answer).to eq("Hola")
    end
  end

  describe "DELETE /decks/:deck_id/cards/:id" do
    let!(:card) do
      deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )
    end

    it "deletes the card" do
      expect do
        delete deck_card_path(deck, card)
      end.to change(Card, :count).by(-1)

      expect(response).to redirect_to(deck_path(deck))
    end
  end
end
