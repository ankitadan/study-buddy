require "rails_helper"

RSpec.describe Review, type: :model do
  let(:deck) { Deck.create!(name: "Spanish") }
  let(:card) { deck.cards.create!(question: "Hello", answer: "Hola") }

  it "is valid with a card, quality, and review date" do
    review = card.reviews.build(quality: 4, reviewed_on: Date.current)

    expect(review).to be_valid
  end

  it "requires a quality that matches a rating" do
    review = card.reviews.build(quality: 2, reviewed_on: Date.current)

    expect(review).not_to be_valid
  end

  it "requires a review date" do
    review = card.reviews.build(quality: 4, reviewed_on: nil)

    expect(review).not_to be_valid
  end

  it "is deleted with its card" do
    card.reviews.create!(quality: 4, reviewed_on: Date.current)

    expect { card.destroy }.to change(Review, :count).by(-1)
  end
end
