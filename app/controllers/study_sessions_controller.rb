class StudySessionsController < ApplicationController
  before_action :set_deck

  def show
    @due_cards = @deck.cards.due
    @card = @due_cards.first
    @remaining_count = @due_cards.count
    @revealed = params[:reveal] == "true"

    show_summary_if_finished
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
      review = Card.transaction do
        card.review(quality)
        card.reviews.create!(quality: quality, reviewed_on: Date.current)
      end
      remember_review(review)

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

  # The IDs of reviews made in the current session are kept in the Rails
  # session so the summary only covers this session. A session left
  # unfinished on an earlier day is discarded.
  def session_key
    "study_session_#{@deck.id}"
  end

  def current_session_review_ids
    data = session[session_key]
    return [] unless data.is_a?(Hash) && data["date"] == Date.current.iso8601

    data["review_ids"]
  end

  def remember_review(review)
    session[session_key] = {
      "date" => Date.current.iso8601,
      "review_ids" => current_session_review_ids + [ review.id ]
    }
  end

  def show_summary_if_finished
    return if @card

    review_ids = current_session_review_ids
    session.delete(session_key)
    @summary = StudySessionSummary.new(@deck, review_ids) if review_ids.any?
  end
end
