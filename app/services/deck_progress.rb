# Calculates the statistics shown on a deck's progress page.
class DeckProgress
  MASTERED_INTERVAL = 21
  NEW_STAGE_PERCENT = 25 # the first review moves a card from New into Learning
  MAX_SIMULATED_REVIEWS = 20
  MILESTONES = [ 3, 7, 14, 30 ].freeze
  WEEKDAY_LABELS = %w[M T W Th F S S].freeze

  WeekDay = Struct.new(:date, :label, :count, :today, :future, keyword_init: true) do
    def studied?
      count.positive?
    end
  end

  attr_reader :deck, :today

  def initialize(deck, today: Date.current)
    @deck = deck
    @today = today
  end

  def due_count
    deck.cards.due.count
  end

  def reviews_count
    reviews_per_day.values.sum
  end

  def cards_count
    deck.cards.count
  end

  # New cards have never been scheduled, learning cards return within three
  # weeks, and mastered cards have an SM-2 interval of 21 days or more.
  def mastery
    intervals = deck.cards.pluck(:interval)

    {
      new: intervals.count(&:zero?),
      learning: intervals.count { |interval| interval.positive? && interval < MASTERED_INTERVAL },
      mastered: intervals.count { |interval| interval >= MASTERED_INTERVAL }
    }
  end

  def mastery_percentages
    total = cards_count
    return mastery.transform_values { 0 } if total.zero?

    mastery.transform_values { |count| (count * 100.0 / total).round }
  end

  # Overall progress of the deck from New (0%) to Mastered (100%), averaged
  # over its cards. A new card is at 0%, a card in learning is between 25% and
  # 99% depending on how many successful reviews it still needs, and a
  # mastered card is at 100%.
  def mastery_progress_percentage
    return 0 if forecasts.empty?

    (forecasts.sum { |forecast| card_progress(forecast) } / forecasts.size).floor
  end

  def cards_to_master
    forecasts.count { |forecast| forecast[:reviews].positive? }
  end

  # Estimates assume every future review is rated Good.
  def reviews_to_mastery
    forecasts.sum { |forecast| forecast[:reviews] }
  end

  def days_to_mastery
    forecasts.map { |forecast| forecast[:days] }.max || 0
  end

  def current_streak
    day = studied_today? ? today : today - 1.day
    streak = 0

    while review_days.include?(day)
      streak += 1
      day -= 1.day
    end

    streak
  end

  def longest_streak
    longest = 0
    run = 0
    previous = nil

    review_days.sort.each do |day|
      run = previous && day == previous + 1.day ? run + 1 : 1
      longest = [ longest, run ].max
      previous = day
    end

    longest
  end

  # :active   - studied today
  # :at_risk  - studied yesterday but not yet today
  # :none     - no current streak
  def streak_status
    return :active if studied_today?
    return :at_risk if current_streak.positive?

    :none
  end

  def studied_today?
    review_days.include?(today)
  end

  # Badges are earned by the longest streak, so they are kept after a streak ends.
  def earned_milestones
    MILESTONES.select { |days| longest_streak >= days }
  end

  def next_milestone
    MILESTONES.find { |days| days > current_streak }
  end

  def days_to_next_milestone
    next_milestone && next_milestone - current_streak
  end

  def streak_goal_percentage
    return 100 unless next_milestone

    (current_streak * 100 / next_milestone).floor
  end

  # The current week, Monday to Sunday.
  def this_week
    monday = today.beginning_of_week(:monday)

    WEEKDAY_LABELS.each_with_index.map do |label, offset|
      date = monday + offset.days

      WeekDay.new(
        date: date,
        label: label,
        count: reviews_per_day.fetch(date, 0),
        today: date == today,
        future: date > today
      )
    end
  end

  def days_studied_this_week
    this_week.count(&:studied?)
  end

  private

  def forecasts
    @forecasts ||= deck.cards.map { |card| mastery_forecast(card) }
  end

  # Simulates Good reviews on an unsaved copy of the card until its interval
  # reaches the mastered threshold.
  def mastery_forecast(card)
    simulated = card.dup
    days =
  if card.interval.zero?
    0
  else
    [ ((card.next_review_date || today) - today).to_i, 0 ].max
  end
    reviews = 0

    while simulated.interval < MASTERED_INTERVAL && reviews < MAX_SIMULATED_REVIEWS
      simulated.schedule(Card::RATINGS["good"], today: today)
      reviews += 1
      # Days until the next simulated review, unless this review mastered the card.
      days += simulated.interval if simulated.interval < MASTERED_INTERVAL
    end

    {
      reviews: reviews,
      days: reviews.zero? ? 0 : days,
      done: card.repetition,
      new: card.interval.zero?
    }
  end

  def card_progress(forecast)
    return 100.0 if forecast[:reviews].zero?
    return 0.0 if forecast[:new]

    completed = forecast[:done].to_f / (forecast[:done] + forecast[:reviews])
    NEW_STAGE_PERCENT + (100 - NEW_STAGE_PERCENT) * completed
  end

  def reviews_per_day
    @reviews_per_day ||= deck.reviews.group(:reviewed_on).count
  end

  def review_days
    @review_days ||= reviews_per_day.keys.to_set
  end
end
