require "rails_helper"

RSpec.describe "cards/show", type: :view do
  let!(:deck) { Deck.create!(name: "Spanish") }

  let!(:card) do
    deck.cards.create!(
      question: "Hello",
      answer: "Hola"
    )
  end

  before do
    assign(:deck, deck)
    assign(:card, card)
  end

  it "displays the question and answer" do
    render

    expect(rendered).to include("Hello")
    expect(rendered).to include("Hola")
  end

  it "displays the SM-2 scheduling details" do
    card.update!(repetition: 2, interval: 6, ease_factor: 2.6, next_review_date: Date.new(2026, 10, 1))

    render

    expect(rendered).to include("October 1, 2026")
    expect(rendered).to include("interval 6 days")
    expect(rendered).to include("2 successful reviews")
    expect(rendered).to include("ease factor 2.6")
  end

  it "includes an edit link" do
    render

    expect(rendered).to include(edit_deck_card_path(deck, card))
  end

  it "includes a delete action for the card" do
    render

    expect(rendered).to include("Destroy this card")
    expect(rendered).to include(deck_card_path(deck, card))
  end

  it "includes a link back to the deck cards" do
    render

    expect(rendered).to include(deck_cards_path(deck))
  end
end
