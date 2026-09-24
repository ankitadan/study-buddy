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

    describe "SM-2 review" do
    it "resets repetition and schedules review for tomorrow with Again" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      card.review(0)

      expect(card.repetition).to eq(0)
      expect(card.interval).to eq(1)
      expect(card.next_review_date).to eq(Date.current + 1.day)
    end

    it "sets interval to 1 day after the first successful review" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      card.review(4)

      expect(card.repetition).to eq(1)
      expect(card.interval).to eq(1)
      expect(card.next_review_date).to eq(Date.current + 1.day)
    end

    it "sets interval to 6 days after the second successful review" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      card.review(4)
      card.review(4)

      expect(card.repetition).to eq(2)
      expect(card.interval).to eq(6)
      expect(card.next_review_date).to eq(Date.current + 6.days)
    end

    it "keeps ease factor unchanged with Good" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      original_ease_factor = card.ease_factor

      card.review(4)

      expect(card.ease_factor).to eq(original_ease_factor)
    end

    it "decreases ease factor with Hard" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      original_ease_factor = card.ease_factor

      card.review(3)

      expect(card.ease_factor).to be < original_ease_factor
    end

    it "increases ease factor with Easy" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      original_ease_factor = card.ease_factor

      card.review(5)

      expect(card.ease_factor).to be > original_ease_factor
    end

    it "never lets the ease factor fall below 1.3" do
  card = deck.cards.create!(
    question: "Hello",
    answer: "Hola"
  )

  10.times { card.review(3) }

  expect(card.ease_factor).to be >= 1.3
end
it "resets the review sequence after Again" do
  card = deck.cards.create!(
    question: "Hello",
    answer: "Hola"
  )

  card.review(4)
  card.review(4)

  expect(card.repetition).to eq(2)
  expect(card.interval).to eq(6)

  card.review(0)

  expect(card.repetition).to eq(0)
  expect(card.interval).to eq(1)
  expect(card.next_review_date).to eq(Date.current + 1.day)
end
  end
end
