class StudySessionsController < ApplicationController
  before_action :set_deck

  def show
    @due_cards = @deck.cards.due
    @card = @due_cards.first
    @remaining_count = @due_cards.count
    @revealed = params[:reveal] == "true"
  end

  def review
    quality = Card::RATINGS[params[:rating]]

    if quality.nil?
      redirect_to deck_study_session_path(@deck),
                  alert: "Please choose Again, Hard, Good, or Easy."
      return
    end

    card = @deck.cards.due.find_by(id: params[:card_id])

    if card
      card.review(quality)
      redirect_to deck_study_session_path(@deck),
                  notice: "Next review of \"#{card.question.truncate(40)}\" is " \
                          "#{card.next_review_date.to_fs(:review)} " \
                          "(in #{helpers.pluralize(card.interval, 'day')})."
    else
      redirect_to deck_study_session_path(@deck),
                  alert: "That card is not due for review."
    end
  end

  private

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end
end
