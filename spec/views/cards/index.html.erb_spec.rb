require "rails_helper"

RSpec.describe "cards/index", type: :view do
  let!(:deck) { Deck.create!(name: "Spanish") }
  let!(:card) do
    deck.cards.create!(
      question: "Hello",
      answer: "Hola"
    )
  end

  before do
    assign(:deck, deck)
    assign(:cards, [card])
  end

  it "displays the card question and answer" do
    render

    expect(rendered).to include("Hello")
    expect(rendered).to include("Hola")
  end

  it "includes a link to show the card" do
    render

    expect(rendered).to include(deck_card_path(deck, card))
  end

  it "includes a link to create a new card" do
    render

    expect(rendered).to include(new_deck_card_path(deck))
  end
end