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
