require "rails_helper"

RSpec.describe Card, type: :model do
  let(:deck) { Deck.create!(name: "Spanish") }

  it "is valid with a question, answer, and deck" do
    card = Card.new(
      question: "Hello",
      answer: "Hola",
      deck: deck
    )

    expect(card).to be_valid
  end

  it "requires a question" do
    card = Card.new(
      question: "",
      answer: "Hola",
      deck: deck
    )

    expect(card).not_to be_valid
    expect(card.errors[:question]).to include("can't be blank")
  end

  it "requires an answer" do
    card = Card.new(
      question: "Hello",
      answer: "",
      deck: deck
    )

    expect(card).not_to be_valid
    expect(card.errors[:answer]).to include("can't be blank")
  end

  it "requires a deck" do
    card = Card.new(
      question: "Hello",
      answer: "Hola",
      deck: nil
    )

    expect(card).not_to be_valid
  end

  it "belongs to a deck" do
    card = deck.cards.create!(
      question: "Hello",
      answer: "Hola"
    )

    expect(card.deck).to eq(deck)
  end

  it "can be edited" do
    card = deck.cards.create!(
      question: "Hello",
      answer: "Hola"
    )

    card.update!(
      question: "Goodbye",
      answer: "Adios"
    )

    expect(card.reload.question).to eq("Goodbye")
    expect(card.reload.answer).to eq("Adios")
  end

  it "can be deleted" do
    card = deck.cards.create!(
      question: "Hello",
      answer: "Hola"
    )

    expect {
      card.destroy
    }.to change(Card, :count).by(-1)
  end

  it "deletes its cards when the deck is deleted" do
    deck.cards.create!(question: "Hello", answer: "Hola")
    deck.cards.create!(question: "Goodbye", answer: "Adios")

    expect {
      deck.destroy
    }.to change(Card, :count).by(-2)
  end
end