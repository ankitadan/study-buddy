require "rails_helper"

RSpec.describe "Deck import, export, and delete controls", type: :request do
  def page
    Nokogiri::HTML(response.body)
  end

  describe "export icon on the decks page" do
    it "links every deck to its own CSV export" do
      spanish = Deck.create!(name: "Spanish")
      french = Deck.create!(name: "French")

      get decks_path

      [ spanish, french ].each do |deck|
        link = page.at_css("##{ActionView::RecordIdentifier.dom_id(deck)} .deck-header a.icon-button")
        expect(link["href"]).to eq(export_deck_cards_path(deck))
        expect(link["aria-label"]).to eq("Export #{deck.name} as CSV")
        expect(link).to have_attribute("download")
        expect(link.at_css("svg.icon")).to be_present
      end
    end

    it "downloads a CSV from the export link" do
      deck = Deck.create!(name: "Spanish")
      deck.cards.create!(question: "Hello", answer: "Hola")

      get export_deck_cards_path(deck)

      expect(response.media_type).to eq("text/csv")
      expect(response.body).to include("Spanish,,Hello,Hola")
    end
  end

describe "import option" do
  it "is shown on the deck page" do
    deck = Deck.create!(name: "Spanish")

    get deck_path(deck)

    form = page.at_css("form.import-form")
    expect(form).to be_present
    expect(form["action"]).to eq(import_deck_cards_path(deck))
    expect(form["enctype"]).to eq("multipart/form-data")
    expect(form.at_css("input[type=file][name=file]")["accept"]).to eq(".csv,text/csv")
    expect(form.text).to include("Import Cards (CSV)")
  end

  it "shows import errors on the deck page" do
    deck = Deck.create!(name: "Spanish")

    post import_deck_cards_path(deck)
    follow_redirect!

    expect(page.text).to include("Please select a CSV file.")
  end
end

  describe "delete confirmation" do
    let!(:deck) { Deck.create!(name: "Spanish") }
    let!(:card) { deck.cards.create!(question: "Hello", answer: "Hola") }

    def delete_form_for(path)
      page.css("form.button_to").find { |form| form["action"] == path }
    end

    it "asks before deleting a deck from the decks page" do
      get decks_path

      expect(delete_form_for(deck_path(deck))["onsubmit"])
        .to eq('return confirm("Delete the deck \"Spanish\" and all its cards?");')
    end

    it "asks before deleting a deck or card from the deck page" do
      get deck_path(deck)

      expect(delete_form_for(deck_path(deck))["onsubmit"])
        .to eq('return confirm("Delete this deck and all its cards?");')
      expect(delete_form_for(deck_card_path(deck, card))["onsubmit"])
        .to eq('return confirm("Delete this card?");')
    end

    it "asks before deleting a card from the card page" do
      get deck_card_path(deck, card)

      expect(delete_form_for(deck_card_path(deck, card))["onsubmit"])
        .to eq('return confirm("Delete this card?");')
    end

    it "safely escapes deck names in the confirmation" do
      deck.update!(name: %q(Tom"s </script> deck))

      get decks_path

      expect(delete_form_for(deck_path(deck))["onsubmit"])
        .to eq('return confirm("Delete the deck \"Tom\"s \u003c/script\u003e deck\" and all its cards?");')
    end

    it "no longer relies on Turbo confirmations" do
      get deck_path(deck)

      expect(response.body).not_to include("data-turbo-confirm")
    end
  end
end
