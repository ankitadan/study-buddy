class CardsController < ApplicationController
  before_action :set_deck
  before_action :set_card, only: %i[show edit update destroy]

  def index
    @cards = @deck.cards
  end

  def show
  end

  def new
    @card = @deck.cards.build
  end

  def create
    @card = @deck.cards.build(card_params)

    if @card.save
      redirect_to deck_path(@deck),
                  notice: "Card was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @card.update(card_params)
      redirect_to deck_path(@deck),
                  notice: "Card was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @card.destroy

    redirect_to deck_path(@deck),
                notice: "Card was successfully deleted."
  end

def export
  require "csv"

  csv_data = CSV.generate(headers: true) do |csv|
    csv << [ "deck_name", "description", "question", "answer" ]

    if @deck.cards.empty?
      csv << [ @deck.name, @deck.description, nil, nil ]
    else
      @deck.cards.each do |card|
        csv << [
          @deck.name,
          @deck.description,
          card.question,
          card.answer
        ]
      end
    end
  end

  send_data csv_data,
            filename: "#{@deck.name.parameterize}-cards.csv",
            type: "text/csv"
end
def import
  require "csv"

  file = params[:file]

  unless file
    redirect_to deck_path(@deck),
                alert: "Please select a CSV file."
    return
  end

  csv = CSV.parse(file.read.force_encoding("UTF-8"), headers: true)

  required_headers = %w[question answer]

  unless required_headers.all? { |header| csv.headers.include?(header) }
    redirect_to deck_path(@deck),
                alert: "Invalid CSV format."
    return
  end

  imported_count = 0
  skipped_count = 0

  csv.each do |row|
    if row["question"].blank? || row["answer"].blank?
      skipped_count += 1
      next
    end

    card = @deck.cards.build(
      question: row["question"],
      answer: row["answer"]
    )

    if card.save
      imported_count += 1
    else
      skipped_count += 1
    end
  end

  if skipped_count.zero?
    notice = "#{imported_count} cards were successfully imported."
  else
    notice = "#{imported_count} cards were imported. #{skipped_count} records were not imported because they contained invalid data."
  end

  redirect_to deck_path(@deck), notice: notice

rescue CSV::MalformedCSVError
  redirect_to deck_path(@deck),
              alert: "Invalid CSV file."
end
  private

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_card
    @card = @deck.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:question, :answer)
  end
end
