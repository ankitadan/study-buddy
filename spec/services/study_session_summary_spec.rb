require "rails_helper"

RSpec.describe StudySessionSummary do
  let(:deck) { Deck.create!(name: "Spanish") }
  let(:card) { deck.cards.create!(question: "Hello", answer: "Hola") }

  def review(quality)
    card.reviews.create!(quality: quality, reviewed_on: Date.current)
  end

  it "summarizes only the given reviews" do
    review(4)
    session_reviews = [ review(0), review(3), review(5), review(5) ]

    summary = described_class.new(deck, session_reviews.map(&:id))

    expect(summary.reviewed_count).to eq(4)
    expect(summary.rating_counts).to eq("again" => 1, "hard" => 1, "good" => 0, "easy" => 2)
    expect(summary.remembered_percentage).to eq(75)
  end

  it "returns zero remembered when there are no reviews" do
    summary = described_class.new(deck, [])

    expect(summary.reviewed_count).to eq(0)
    expect(summary.remembered_percentage).to eq(0)
  end

  it "ignores reviews from another deck" do
    other_card = Deck.create!(name: "French").cards.create!(question: "Bonjour", answer: "Hi")
    other_review = other_card.reviews.create!(quality: 4, reviewed_on: Date.current)

    expect(described_class.new(deck, [ other_review.id ]).reviewed_count).to eq(0)
  end

  it "reports the earliest upcoming review date in the deck" do
    card.update!(next_review_date: Date.current + 6.days)
    deck.cards.create!(question: "Soon", answer: "a", next_review_date: Date.current + 1.day)

    expect(described_class.new(deck, []).next_review_date).to eq(Date.current + 1.day)
  end
end
