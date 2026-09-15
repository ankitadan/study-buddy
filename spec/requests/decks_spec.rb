require "rails_helper"

RSpec.describe "Decks", type: :request do
  describe "GET /decks" do
    it "returns a successful response" do
      get decks_path

      expect(response).to have_http_status(:ok)
    end

    it "displays existing decks" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get decks_path

      expect(response.body).to include(deck.name)
      expect(response.body).to include(deck.description)
    end
  end

  describe "GET /decks/new" do
    it "returns a successful response" do
      get new_deck_path

      expect(response).to have_http_status(:ok)
    end

    it "displays the create deck form" do
      get new_deck_path

      expect(response.body).to include("Create a New Deck")
      expect(response.body).to include("Name")
      expect(response.body).to include("Description")
    end
  end

  describe "POST /decks" do
    it "does not create a deck without a name" do
      expect do
        post decks_path, params: {
            deck: {
                name: "",
                description: "Programming for Web Dev"
            }
        }
    end.not_to change(Deck, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    end
    it "creates a new deck" do
      expect do
        post decks_path, params: {
          deck: {
            name: "Java",
            description: "Programming for Web Dev"
          }
        }
      end.to change(Deck, :count).by(1)
    end

    it "stores the deck information correctly" do
      post decks_path, params: {
        deck: {
          name: "Java",
          description: "Programming for Web Dev"
        }
      }

      deck = Deck.last

      expect(deck.name).to eq("Java")
      expect(deck.description).to eq("Programming for Web Dev")
    end

    it "redirects to the created deck" do
      post decks_path, params: {
        deck: {
          name: "Java",
          description: "Programming for Web Dev"
        }
      }

      expect(response).to redirect_to(deck_path(Deck.last))
    end
  end

  describe "GET /decks/:id" do
    it "returns a successful response" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response).to have_http_status(:ok)
    end

    it "displays the deck name" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response.body).to include("Java")
    end

    it "displays the deck description" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response.body).to include("Programming for Web Dev")
    end

    it "displays the card management options" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response.body).to include("Add New Card")
      expect(response.body).to include("Delete This Deck")
    end
  end

  describe "GET /decks/:id/edit" do
    it "returns a successful response" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get edit_deck_path(deck)

      expect(response).to have_http_status(:ok)
    end

    it "displays the existing deck information" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get edit_deck_path(deck)

      expect(response.body).to include("Java")
      expect(response.body).to include("Programming for Web Dev")
    end
  end

describe "PATCH /decks/:id" do
  it "updates the deck" do
    deck = Deck.create!(
      name: "Java",
      description: "Programming for Web Dev"
    )

    patch deck_path(deck), params: {
      deck: {
        name: "Advanced Java",
        description: "Advanced Java programming"
      }
    }

    deck.reload

    expect(deck.name).to eq("Advanced Java")
    expect(deck.description).to eq("Advanced Java programming")
  end

  it "redirects to the updated deck" do
    deck = Deck.create!(
      name: "Java",
      description: "Programming for Web Dev"
    )

    patch deck_path(deck), params: {
      deck: {
        name: "Advanced Java",
        description: "Advanced Java programming"
      }
    }

    expect(response).to redirect_to(deck_path(deck))
  end

  it "does not update the deck with an invalid name" do
    deck = Deck.create!(
      name: "Java",
      description: "Programming for Web Dev"
    )

    patch deck_path(deck), params: {
      deck: {
        name: "",
        description: "Updated description"
      }
    }

    deck.reload

    expect(deck.name).to eq("Java")
    expect(deck.description).to eq("Programming for Web Dev")
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

  describe "DELETE /decks/:id" do
    it "deletes the deck" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      expect do
        delete deck_path(deck)
      end.to change(Deck, :count).by(-1)
    end
    it "redirects to the decks index after deletion" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      delete deck_path(deck)

      expect(response).to redirect_to(decks_path)
    end

    it "deletes associated cards when the deck is deleted" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      deck.cards.create!(
        question: "What is Java?",
        answer: "A programming language"
      )

      expect do
        delete deck_path(deck)
      end.to change(Card, :count).by(-1)
    end
  end
end