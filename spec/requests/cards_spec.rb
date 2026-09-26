require "rails_helper"

RSpec.describe "Cards", type: :request do
  let!(:deck) { Deck.create!(name: "Spanish") }

  describe "GET /decks/:deck_id/cards" do
    it "returns a successful response" do
      get deck_cards_path(deck)

      expect(response).to have_http_status(:ok)
    end

    it "displays cards belonging to the selected deck" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      get deck_cards_path(deck)

      expect(response.body).to include(card.question)
      expect(response.body).to include(card.answer)
    end

    it "does not display cards from another deck" do
      other_deck = Deck.create!(name: "French")

      other_card = other_deck.cards.create!(
        question: "Bonjour",
        answer: "Hello"
      )

      get deck_cards_path(deck)

      expect(response.body).not_to include(other_card.question)
      expect(response.body).not_to include(other_card.answer)
    end

    it "returns successfully when the deck has no cards" do
      get deck_cards_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Cards")
    end
  end

  describe "GET /decks/:deck_id/cards/new" do
    it "shows the new card form" do
      get new_deck_card_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Question")
      expect(response.body).to include("Answer")
    end
  end

  describe "GET /decks/:deck_id/cards/:id" do
    it "shows the requested card" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      get deck_card_path(deck, card)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(card.question)
      expect(response.body).to include(card.answer)
    end
  end

  describe "GET /decks/:deck_id/cards/:id/edit" do
    it "shows the card edit form with existing information" do
      card = deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      get edit_deck_card_path(deck, card)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello")
      expect(response.body).to include("Hola")
      expect(response.body).to include("Question")
      expect(response.body).to include("Answer")
    end
  end

  describe "POST /decks/:deck_id/cards" do
    it "creates a card with valid input" do
      expect do
        post deck_cards_path(deck), params: {
          card: {
            question: "Hello",
            answer: "Hola"
          }
        }
      end.to change(Card, :count).by(1)

      expect(response).to redirect_to(deck_path(deck))
      expect(Card.last.deck).to eq(deck)
    end

    it "does not create a card with a blank question" do
      expect do
        post deck_cards_path(deck), params: {
          card: {
            question: "",
            answer: "Hola"
          }
        }
      end.not_to change(Card, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "does not create a card with a blank answer" do
      expect do
        post deck_cards_path(deck), params: {
          card: {
            question: "Hello",
            answer: ""
          }
        }
      end.not_to change(Card, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /decks/:deck_id/cards/:id" do
    let!(:card) do
      deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )
    end

    it "updates a card with valid input" do
      patch deck_card_path(deck, card), params: {
        card: {
          question: "Goodbye",
          answer: "Adios"
        }
      }

      expect(response).to redirect_to(deck_path(deck))
      expect(card.reload.question).to eq("Goodbye")
      expect(card.reload.answer).to eq("Adios")
    end

    it "does not update a card with invalid input" do
      patch deck_card_path(deck, card), params: {
        card: {
          question: "",
          answer: ""
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(card.reload.question).to eq("Hello")
      expect(card.reload.answer).to eq("Hola")
    end
  end

  describe "DELETE /decks/:deck_id/cards/:id" do
    let!(:card) do
      deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )
    end

    it "deletes the card" do
      expect do
        delete deck_card_path(deck, card)
      end.to change(Card, :count).by(-1)

      expect(response).to redirect_to(deck_path(deck))
    end
  end
    describe "GET /decks/:deck_id/cards/export" do
    it "returns a CSV file" do
      get export_deck_cards_path(deck)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/csv")
    end

    it "exports the deck information" do
      get export_deck_cards_path(deck)

      expect(response.body).to include("deck_name")
      expect(response.body).to include("description")
      expect(response.body).to include("Spanish")
    end

    it "exports a card's question and answer" do
      deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      get export_deck_cards_path(deck)

      expect(response.body).to include("Hello")
      expect(response.body).to include("Hola")
    end

    it "exports multiple cards" do
      deck.cards.create!(
        question: "Hello",
        answer: "Hola"
      )

      deck.cards.create!(
        question: "Goodbye",
        answer: "Adios"
      )

      get export_deck_cards_path(deck)

      expect(response.body).to include("Hello")
      expect(response.body).to include("Hola")
      expect(response.body).to include("Goodbye")
      expect(response.body).to include("Adios")
    end

    it "returns the CSV header when the deck has no cards" do
      get export_deck_cards_path(deck)

      expect(response.body).to include(
        "deck_name,description,question,answer"
      )
    end

    it "does not export cards from another deck" do
      other_deck = Deck.create!(name: "French")

      other_deck.cards.create!(
        question: "Bonjour",
        answer: "Hello"
      )

      get export_deck_cards_path(deck)

      expect(response.body).not_to include("Bonjour")
      expect(response.body).not_to include("Hello")
    end
    it "exports cards containing commas" do
  deck.cards.create!(
    question: "What is Ruby, exactly?",
    answer: "A programming language, mainly."
  )

  get export_deck_cards_path(deck)

  expect(response.body).to include("What is Ruby, exactly?")
  expect(response.body).to include("A programming language, mainly.")
end

it "exports cards containing quotes" do
  deck.cards.create!(
    question: 'What does "Ruby" mean?',
    answer: 'It is a "programming language".'
  )

  get export_deck_cards_path(deck)

  expect(response.body).to include('"Ruby"')
  expect(response.body).to include('"programming language"')
end

it "exports cards containing newlines" do
  deck.cards.create!(
    question: "What is Ruby?\nGive one example.",
    answer: "A programming language.\nIt is used with Rails."
  )

  get export_deck_cards_path(deck)

  expect(response.body).to include("What is Ruby?")
  expect(response.body).to include("Give one example.")
  expect(response.body).to include("A programming language.")
  expect(response.body).to include("It is used with Rails.")
 end
  end
  describe "POST /decks/:deck_id/cards/import" do
it "imports cards into the existing deck" do
  csv = <<~CSV
    question,answer
    What is Ruby?,A programming language
    What is Rails?,A web framework
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  expect do
    post import_deck_cards_path(deck), params: {
      file: Rack::Test::UploadedFile.new(file.path, "text/csv")
    }
  end.to change(Card, :count).by(2)

  expect(response).to redirect_to(deck_path(deck))

  file.close
  file.unlink
end
it "imports cards into the selected deck" do
  other_deck = Deck.create!(name: "French")

  csv = <<~CSV
    question,answer
    Hello,Hola
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  post import_deck_cards_path(deck), params: {
    file: Rack::Test::UploadedFile.new(file.path, "text/csv")
  }

  imported_card = Card.find_by(question: "Hello")

  expect(imported_card.deck).to eq(deck)
  expect(imported_card.deck).not_to eq(other_deck)

  file.close
  file.unlink
end
it "does not import when no file is provided" do
  expect do
    post import_deck_cards_path(deck)
  end.not_to change(Card, :count)

  expect(response).to redirect_to(deck_path(deck))
end
it "does not import a CSV with missing required headers" do
  csv = <<~CSV
    question,wrong_header
    What is Ruby?,A programming language
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  expect do
    post import_deck_cards_path(deck), params: {
      file: Rack::Test::UploadedFile.new(file.path, "text/csv")
    }
  end.not_to change(Card, :count)

  expect(response).to redirect_to(deck_path(deck))

  file.close
  file.unlink
end
it "does not import when a question is blank" do
  csv = <<~CSV
    question,answer
    ,A programming language
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  expect do
    post import_deck_cards_path(deck), params: {
      file: Rack::Test::UploadedFile.new(file.path, "text/csv")
    }
  end.not_to change(Card, :count)

  expect(response).to redirect_to(deck_path(deck))

  file.close
  file.unlink
end
it "does not import when an answer is blank" do
  csv = <<~CSV
    question,answer
    What is Ruby?,
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  expect do
    post import_deck_cards_path(deck), params: {
      file: Rack::Test::UploadedFile.new(file.path, "text/csv")
    }
  end.not_to change(Card, :count)

  expect(response).to redirect_to(deck_path(deck))

  file.close
  file.unlink
end
it "imports cards containing commas" do
  csv = <<~CSV
    question,answer
    "What is Ruby, exactly?","A programming language, mainly."
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  post import_deck_cards_path(deck), params: {
    file: Rack::Test::UploadedFile.new(file.path, "text/csv")
  }

  card = deck.cards.find_by(question: "What is Ruby, exactly?")

  expect(card).not_to be_nil
  expect(card.answer).to eq("A programming language, mainly.")

  file.close
  file.unlink
end
it "imports cards containing quotes" do
  csv = <<~CSV
    question,answer
    "What does ""Ruby"" mean?","It is a ""programming language""."
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  post import_deck_cards_path(deck), params: {
    file: Rack::Test::UploadedFile.new(file.path, "text/csv")
  }

  card = deck.cards.find_by(question: 'What does "Ruby" mean?')

  expect(card).not_to be_nil
  expect(card.answer).to eq('It is a "programming language".')

  file.close
  file.unlink
end
it "imports cards containing newlines" do
  csv = <<~CSV
    question,answer
    "What is Ruby?
    Give one example.","A programming language.
    It is used with Rails."
  CSV

  file = Tempfile.new([ "cards", ".csv" ])
  file.write(csv)
  file.rewind

  post import_deck_cards_path(deck), params: {
    file: Rack::Test::UploadedFile.new(file.path, "text/csv")
  }

  card = deck.cards.find_by(question: "What is Ruby?\nGive one example.")

  expect(card).not_to be_nil
  expect(card.answer).to eq("A programming language.\nIt is used with Rails.")

  file.close
  file.unlink
end
end
end
