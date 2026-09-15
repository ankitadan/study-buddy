require "rails_helper"

RSpec.describe "Cards", type: :request do
  let!(:deck) { Deck.create!(name: "Spanish") }

  describe "GET /decks/:deck_id/cards/new" do
    it "shows the new card form" do
      get new_deck_card_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Question")
      expect(response.body).to include("Answer")
    end
  end

  describe "POST /decks/:deck_id/cards" do
    it "creates a card with valid input" do
      expect {
        post deck_cards_path(deck), params: {
          card: {
            question: "Hello",
            answer: "Hola"
          }
        }
      }.to change(Card, :count).by(1)

      expect(response).to redirect_to(deck_path(deck))
      expect(Card.last.deck).to eq(deck)
    end

    it "does not create a card with a blank question" do
      expect {
        post deck_cards_path(deck), params: {
          card: {
            question: "",
            answer: "Hola"
          }
        }
      }.not_to change(Card, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not create a card with a blank answer" do
      expect {
        post deck_cards_path(deck), params: {
          card: {
            question: "Hello",
            answer: ""
          }
        }
      }.not_to change(Card, :count)

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
      expect {
        delete deck_card_path(deck, card)
      }.to change(Card, :count).by(-1)

      expect(response).to redirect_to(deck_path(deck))
    end
  end
end