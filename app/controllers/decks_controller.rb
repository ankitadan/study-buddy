class DecksController < ApplicationController
  before_action :set_deck, only: %i[show edit update destroy]

  def index
    @decks = Deck.all
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new(deck_params)

    if @deck.save
      redirect_to @deck, notice: "Deck was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @cards = @deck.cards.order(:id)

    if @cards.any?
      @card = @cards.find_by(id: params[:card_id]) || @cards.first

      @previous_card = @cards.where("id < ?", @card.id).last
      @next_card = @cards.where("id > ?", @card.id).first
    end
  end

  def edit
  end

  def update
    if @deck.update(deck_params)
      redirect_to @deck, notice: "Deck was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @deck.destroy

    redirect_to decks_path,
                notice: "Deck was successfully deleted."
  end

  def import
  require "csv"

  file = params[:file]

  unless file
    redirect_to decks_path, alert: "Please select a CSV file."
    return
  end

  csv = CSV.parse(file.read.force_encoding("UTF-8"), headers: true)

  required_headers = %w[deck_name description question answer]

  unless required_headers.all? { |header| csv.headers.include?(header) }
    redirect_to decks_path, alert: "Invalid CSV format."
    return
  end

  deck_name = csv.first["deck_name"]

  if deck_name.blank?
    redirect_to decks_path, alert: "Deck name cannot be blank."
    return
  end

  deck = Deck.new(
    name: deck_name,
    description: csv.first["description"]
  )

  csv.each do |row|
    if row["question"].blank? || row["answer"].blank?
      redirect_to decks_path,
                  alert: "Question and answer cannot be blank."
      return
    end

    deck.cards.build(
      question: row["question"],
      answer: row["answer"]
    )
  end

  if deck.save
    redirect_to deck_path(deck),
                notice: "Deck was successfully imported."
  else
    redirect_to decks_path,
                alert: "Unable to import deck."
  end
rescue CSV::MalformedCSVError
  redirect_to decks_path, alert: "Invalid CSV file."
end

  private

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name, :description)
  end
end
