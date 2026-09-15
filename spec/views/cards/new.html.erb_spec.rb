require "rails_helper"

RSpec.describe "cards/edit", type: :view do
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

  it "renders the edit form" do
    render

    expect(rendered).to include("Question")
    expect(rendered).to include("Answer")
    expect(rendered).to include("Hello")
    expect(rendered).to include("Hola")
  end

  it "includes a link back to the cards list" do
    render

    expect(rendered).to include(deck_cards_path(deck))
  end
end
