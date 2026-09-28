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

    if save_deck { @deck.save }
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
    if save_deck { @deck.update(deck_params) }
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


  private

  # The unique index on decks.name catches a duplicate that slips past the
  # model validation (two saves at once), so show it as a form error too.
  def save_deck
    yield
  rescue ActiveRecord::RecordNotUnique
    @deck.errors.add(:name, :taken, message: "is already used by another deck")
    false
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name, :description)
  end
end
