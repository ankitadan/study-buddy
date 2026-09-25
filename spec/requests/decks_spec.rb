require "rails_helper"

RSpec.describe "Decks", type: :request do
  describe "GET /decks" do
    it "returns a successful response" do
      get decks_path

      expect(response).to have_http_status(:ok)
    end

    it "displays existing decks" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get decks_path

      expect(response.body).to include(deck.name)
      expect(response.body).to include(deck.description)
    end
  end

  describe "GET /decks progress" do
    it "shows an empty-state message when there are no decks" do
      get decks_path

      expect(response.body).to include("You do not have any decks yet")
    end

    it "shows zero progress for a new deck" do
      deck = Deck.create!(name: "Spanish")

      get decks_path

      progress = Nokogiri::HTML(response.body).at_css("##{ActionView::RecordIdentifier.dom_id(deck)} .deck-progress").text.squish
      expect(progress).to eq("Due today 0 Total reviews 0 Study streak 0 days")
    end

    it "shows due cards, total reviews, and streak for each deck" do
      spanish = Deck.create!(name: "Spanish")
      french = Deck.create!(name: "French")
      card = spanish.cards.create!(question: "Hello", answer: "Hola")
      spanish.cards.create!(question: "Goodbye", answer: "Adios")
      card.reviews.create!(quality: 4, reviewed_on: Date.current)
      card.reviews.create!(quality: 3, reviewed_on: Date.current - 1.day)

      get decks_path

      page = Nokogiri::HTML(response.body)
      spanish_progress = page.at_css("##{ActionView::RecordIdentifier.dom_id(spanish)} .deck-progress").text.squish
      french_progress = page.at_css("##{ActionView::RecordIdentifier.dom_id(french)} .deck-progress").text.squish

      expect(spanish_progress).to eq("Due today 2 Total reviews 2 Study streak 2 days")
      expect(french_progress).to eq("Due today 0 Total reviews 0 Study streak 0 days")
    end

    it "links each deck to its study session" do
      deck = Deck.create!(name: "Spanish")

      get decks_path

      expect(response.body).to include(deck_study_session_path(deck))
    end
  end

  describe "GET /decks/new" do
    it "returns a successful response" do
      get new_deck_path

      expect(response).to have_http_status(:ok)
    end

    it "displays the create deck form" do
      get new_deck_path

      expect(response.body).to include("Create a New Deck")
      expect(response.body).to include("Name")
      expect(response.body).to include("Description")
    end
  end

  describe "POST /decks" do
    it "does not create a deck without a name" do
      expect do
        post decks_path, params: {
            deck: {
                name: "",
                description: "Programming for Web Dev"
            }
        }
    end.not_to change(Deck, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    end
    it "creates a new deck" do
      expect do
        post decks_path, params: {
          deck: {
            name: "Java",
            description: "Programming for Web Dev"
          }
        }
      end.to change(Deck, :count).by(1)
    end

    it "stores the deck information correctly" do
      post decks_path, params: {
        deck: {
          name: "Java",
          description: "Programming for Web Dev"
        }
      }

      deck = Deck.last

      expect(deck.name).to eq("Java")
      expect(deck.description).to eq("Programming for Web Dev")
    end

    it "redirects to the created deck" do
      post decks_path, params: {
        deck: {
          name: "Java",
          description: "Programming for Web Dev"
        }
      }

      expect(response).to redirect_to(deck_path(Deck.last))
    end
  end

  describe "GET /decks/:id" do
    it "returns a successful response" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response).to have_http_status(:ok)
    end

    it "displays the deck name" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response.body).to include("Java")
    end

    it "displays the deck description" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response.body).to include("Programming for Web Dev")
    end

    it "displays the card management options" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get deck_path(deck)

      expect(response.body).to include("Add New Card")
      expect(response.body).to include("Delete This Deck")
    end
  end

  describe "GET /decks/:id/edit" do
    it "returns a successful response" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get edit_deck_path(deck)

      expect(response).to have_http_status(:ok)
    end

    it "displays the existing deck information" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      get edit_deck_path(deck)

      expect(response.body).to include("Java")
      expect(response.body).to include("Programming for Web Dev")
    end
  end

describe "PATCH /decks/:id" do
  it "updates the deck" do
    deck = Deck.create!(
      name: "Java",
      description: "Programming for Web Dev"
    )

    patch deck_path(deck), params: {
      deck: {
        name: "Advanced Java",
        description: "Advanced Java programming"
      }
    }

    deck.reload

    expect(deck.name).to eq("Advanced Java")
    expect(deck.description).to eq("Advanced Java programming")
  end

  it "redirects to the updated deck" do
    deck = Deck.create!(
      name: "Java",
      description: "Programming for Web Dev"
    )

    patch deck_path(deck), params: {
      deck: {
        name: "Advanced Java",
        description: "Advanced Java programming"
      }
    }

    expect(response).to redirect_to(deck_path(deck))
  end

  it "does not update the deck with an invalid name" do
    deck = Deck.create!(
      name: "Java",
      description: "Programming for Web Dev"
    )

    patch deck_path(deck), params: {
      deck: {
        name: "",
        description: "Updated description"
      }
    }

    deck.reload

    expect(deck.name).to eq("Java")
    expect(deck.description).to eq("Programming for Web Dev")
    expect(response).to have_http_status(:unprocessable_entity)
  end
end

  describe "DELETE /decks/:id" do
    it "deletes the deck" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      expect do
        delete deck_path(deck)
      end.to change(Deck, :count).by(-1)
    end
    it "redirects to the decks index after deletion" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      delete deck_path(deck)

      expect(response).to redirect_to(decks_path)
    end

    it "deletes associated cards when the deck is deleted" do
      deck = Deck.create!(
        name: "Java",
        description: "Programming for Web Dev"
      )

      deck.cards.create!(
        question: "What is Java?",
        answer: "A programming language"
      )

      expect do
        delete deck_path(deck)
      end.to change(Card, :count).by(-1)
    end
  end

    describe "GET /decks/:id card navigation" do
    let!(:deck) do
      Deck.create!(
        name: "Spanish",
        description: "Spanish vocabulary"
      )
    end

    let!(:first_card) do
      deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )
    end

    let!(:second_card) do
      deck.cards.create!(
        question: "Goodbye",
        answer: "Adios"
      )
    end

    let!(:third_card) do
      deck.cards.create!(
        question: "Thank you",
        answer: "Gracias"
      )
    end

    it "displays the first card by default" do
      get deck_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(first_card.question)
      expect(response.body).to include(first_card.answer)
      expect(response.body).not_to include(second_card.question)
      expect(response.body).to include("Next Card")
      expect(response.body).not_to include("Previous Card")
    end

    it "displays the selected card" do
      get deck_path(deck), params: { card_id: second_card.id }

      expect(response.body).to include(second_card.question)
      expect(response.body).to include(second_card.answer)
      expect(response.body).not_to include(first_card.question)
    end

    it "displays previous and next navigation for a middle card" do
      get deck_path(deck), params: { card_id: second_card.id }

      expect(response.body).to include("Previous Card")
      expect(response.body).to include("Next Card")
      expect(response.body).to include("card_id=#{first_card.id}")
      expect(response.body).to include("card_id=#{third_card.id}")
    end

    it "does not display Previous Card for the first card" do
      get deck_path(deck), params: { card_id: first_card.id }

      expect(response.body).not_to include("Previous Card")
      expect(response.body).to include("Next Card")
    end

    it "does not display Next Card for the last card" do
      get deck_path(deck), params: { card_id: third_card.id }

      expect(response.body).to include("Previous Card")
      expect(response.body).not_to include("Next Card")
    end

    it "defaults to the first card when the card id is invalid" do
      get deck_path(deck), params: { card_id: 999_999 }

      expect(response.body).to include(first_card.question)
      expect(response.body).not_to include(second_card.question)
    end

    it "does not display cards from another deck" do
      other_deck = Deck.create!(name: "French")
      other_card = other_deck.cards.create!(
        question: "Bonjour",
        answer: "Hello"
      )

      get deck_path(deck), params: { card_id: other_card.id }

      expect(response.body).to include(first_card.question)
      expect(response.body).not_to include(other_card.question)
    end

    it "displays an empty message when the deck has no cards" do
      empty_deck = Deck.create!(name: "Empty Deck")

      get deck_path(empty_deck)

      expect(response.body).to include(
        "This deck does not have any cards yet."
      )
      expect(response.body).to include("Add Your First Card")
    end
  end
  describe "POST /decks/import" do
  it "creates a new deck from a valid CSV file" do
    csv = <<~CSV
      deck_name,description,question,answer
      French,French vocabulary,Hello,Bonjour
    CSV

    file = Rack::Test::UploadedFile.new(
      StringIO.new(csv),
      "text/csv",
      original_filename: "french.csv"
    )

    expect do
      post import_decks_path, params: { file: file }
    end.to change(Deck, :count).by(1)

    deck = Deck.last

    expect(deck.name).to eq("French")
    expect(deck.description).to eq("French vocabulary")
    expect(response).to redirect_to(deck_path(deck))
  end

  it "creates cards belonging to the imported deck" do
    csv = <<~CSV
      deck_name,description,question,answer
      French,French vocabulary,Hello,Bonjour
      French,French vocabulary,Goodbye,Au revoir
    CSV

    file = Rack::Test::UploadedFile.new(
      StringIO.new(csv),
      "text/csv",
      original_filename: "french.csv"
    )

    expect do
      post import_decks_path, params: { file: file }
    end.to change(Card, :count).by(2)

    deck = Deck.last

    expect(deck.cards.map(&:question)).to contain_exactly(
      "Hello",
      "Goodbye"
    )

    expect(deck.cards.map(&:answer)).to contain_exactly(
      "Bonjour",
      "Au revoir"
    )
  end
  it "does not import when no file is provided" do
  expect do
    post import_decks_path
  end.not_to change(Deck, :count)

  expect(response).to redirect_to(decks_path)
end
it "does not import a CSV with missing required headers" do
  csv = <<~CSV
    deck_name,question,answer
    French,Hello,Bonjour
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "invalid.csv"
  )

  expect do
    post import_decks_path, params: { file: file }
  end.not_to change(Deck, :count)

  expect(response).to redirect_to(decks_path)
end
it "does not import when the deck name is blank" do
  csv = <<~CSV
    deck_name,description,question,answer
    ,French vocabulary,Hello,Bonjour
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "invalid.csv"
  )

  expect do
    post import_decks_path, params: { file: file }
  end.not_to change(Deck, :count)

  expect(response).to redirect_to(decks_path)
end
it "does not import when a question is blank" do
  csv = <<~CSV
    deck_name,description,question,answer
    French,French vocabulary,,Bonjour
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "invalid.csv"
  )

  expect do
    post import_decks_path, params: { file: file }
  end.not_to change(Deck, :count)

  expect(response).to redirect_to(decks_path)
end
it "does not import when an answer is blank" do
  csv = <<~CSV
    deck_name,description,question,answer
    French,French vocabulary,Hello,
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "invalid.csv"
  )

  expect do
    post import_decks_path, params: { file: file }
  end.not_to change(Deck, :count)

  expect(response).to redirect_to(decks_path)
end
it "imports cards containing commas" do
  csv = <<~CSV
    deck_name,description,question,answer
    French,French vocabulary,"What is Ruby, exactly?","A programming language, mainly."
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "french.csv"
  )

  post import_decks_path, params: { file: file }

  card = Deck.last.cards.first

  expect(card.question).to eq("What is Ruby, exactly?")
  expect(card.answer).to eq("A programming language, mainly.")
end
it "imports cards containing quotes" do
  csv = <<~CSV
    deck_name,description,question,answer
    French,French vocabulary,"What does ""Ruby"" mean?","It is a ""programming language""."
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "french.csv"
  )

  post import_decks_path, params: { file: file }

  card = Deck.last.cards.first

  expect(card.question).to eq('What does "Ruby" mean?')
  expect(card.answer).to eq('It is a "programming language".')
end
it "imports cards containing newlines" do
  csv = <<~CSV
    deck_name,description,question,answer
    French,French vocabulary,"What is Ruby?
    Give one example.","A programming language.
    It is used with Rails."
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "french.csv"
  )

  post import_decks_path, params: { file: file }

  card = Deck.last.cards.first

  expect(card.question).to eq("What is Ruby?\nGive one example.")
  expect(card.answer).to eq("A programming language.\nIt is used with Rails.")
end
it "does not create a deck or cards when any row is invalid" do
  csv = <<~CSV
    deck_name,description,question,answer
    French,French vocabulary,Hello,Bonjour
    French,French vocabulary,,Au revoir
  CSV

  file = Rack::Test::UploadedFile.new(
    StringIO.new(csv),
    "text/csv",
    original_filename: "invalid.csv"
  )

  expect do
    post import_decks_path, params: { file: file }
  end.to change(Deck, :count).by(0)
   .and change(Card, :count).by(0)

  expect(response).to redirect_to(decks_path)
end
it "preserves deck and card data through export and import" do
  original_deck = Deck.create!(
    name: "Spanish",
    description: "Spanish vocabulary"
  )

  original_deck.cards.create!(
    question: "Hello, world!",
    answer: "¡Hola, mundo!"
  )

  original_deck.cards.create!(
    question: 'What does "gracias" mean?',
    answer: "Thank you"
  )

  get export_deck_cards_path(original_deck)

  exported_csv = response.body

  file = Rack::Test::UploadedFile.new(
    StringIO.new(exported_csv),
    "text/csv",
    original_filename: "spanish-cards.csv"
  )

  expect do
    post import_decks_path, params: { file: file }
  end.to change(Deck, :count).by(1)

  imported_deck = Deck.last

  expect(imported_deck.name).to eq(original_deck.name)
  expect(imported_deck.description).to eq(original_deck.description)

  expect(imported_deck.cards.pluck(:question, :answer)).to contain_exactly(
    [ "Hello, world!", "¡Hola, mundo!" ],
    [ 'What does "gracias" mean?', "Thank you" ]
  )
end
end
end
