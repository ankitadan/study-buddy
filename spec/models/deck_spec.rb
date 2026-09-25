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

  describe "progress" do
    let(:deck) { Deck.create!(name: "Spanish") }
    let(:card) { deck.cards.create!(question: "Hello", answer: "Hola") }
    let(:today) { Date.current }

    def review_on(date, reviewed_card = card)
      reviewed_card.reviews.create!(quality: 4, reviewed_on: date)
    end

    it "returns zeros when the deck has no cards or reviews" do
      expect(deck.due_cards_count).to eq(0)
      expect(deck.reviews_count).to eq(0)
      expect(deck.current_streak).to eq(0)
    end

    it "counts cards due today or earlier" do
      card
      deck.cards.create!(question: "Later", answer: "Luego", next_review_date: today + 2.days)

      expect(deck.due_cards_count).to eq(1)
    end

    it "counts every review in the deck" do
      review_on(today)
      review_on(today)
      review_on(today - 1.day)

      expect(deck.reviews_count).to eq(3)
    end

    it "does not count reviews from another deck" do
      other_card = Deck.create!(name: "French").cards.create!(question: "Bonjour", answer: "Hello")
      review_on(today, other_card)

      expect(deck.reviews_count).to eq(0)
      expect(deck.current_streak).to eq(0)
    end

    it "has a one-day streak after studying today" do
      review_on(today)

      expect(deck.current_streak).to eq(1)
    end

    it "counts several reviews on the same day once" do
      3.times { review_on(today) }

      expect(deck.current_streak).to eq(1)
    end

    it "counts consecutive study days" do
      review_on(today)
      review_on(today - 1.day)
      review_on(today - 2.days)

      expect(deck.current_streak).to eq(3)
    end

    it "keeps the streak from yesterday when the learner has not studied yet today" do
      review_on(today - 1.day)
      review_on(today - 2.days)

      expect(deck.current_streak).to eq(2)
    end

    it "stops counting at the first missed day" do
      review_on(today)
      review_on(today - 2.days)

      expect(deck.current_streak).to eq(1)
    end

    it "resets to zero after missing more than a day" do
      review_on(today - 2.days)

      expect(deck.current_streak).to eq(0)
    end
  end
end
