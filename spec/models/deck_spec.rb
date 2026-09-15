require "rails_helper"

RSpec.describe Deck, type: :model do
  describe "creation" do
    it "is valid with a name and description" do
      deck = Deck.new(
        name: "Java",
        description: "Programming for Web Dev"
      )

      expect(deck).to be_valid
    end

    it "can be saved to the database" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      expect(deck).to be_persisted
    end

    it "stores the name correctly" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      expect(deck.name).to eq("Java")
    end

    it "stores the description correctly" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      expect(deck.description).to eq("Programming for Web Dev")
    end
  end

  describe "cards association" do
    it "has many cards" do
      association = Deck.reflect_on_association(:cards)

      expect(association).not_to be_nil
      expect(association.macro).to eq(:has_many)
    end

    it "destroys associated cards when the deck is destroyed" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      deck.cards.create!(
        question: "What is Java?",
        answer: "A programming language"
      )

      expect { deck.destroy }.to change(Card, :count).by(-1)
    end
  end
end
