class DeckProgressController < ApplicationController
  def show
    @deck = Deck.find(params[:deck_id])
    @progress = DeckProgress.new(@deck)
  end
end
