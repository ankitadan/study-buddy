require "rails_helper"


RSpec.describe Card, type: :model do
  it "should have a question and an answer" do
    deck = Deck.create!(name: "Spanish")

    card = Card.create!(
      question: "Hello",
      answer: "Hola",
      deck: deck
    )

    expect(card.question).to eq("Hello")
    expect(card.answer).to eq("Hola")
  end

  it "should have a deck reference" do
    deck = Deck.create!(name: "Spanish")

    card = Card.create!(
      question: "Hello",
      answer: "Hola",
      deck: deck
    )

    expect(card.deck).to eq(deck)
    expect(card.deck_id).to eq(deck.id)
  end
end
