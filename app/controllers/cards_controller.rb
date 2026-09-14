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
