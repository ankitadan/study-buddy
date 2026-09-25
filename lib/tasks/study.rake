namespace :study do
  def study_cards
    abort "Study tasks are for development and test only." if Rails.env.production?

    ENV["DECK_ID"].present? ? Deck.find(ENV["DECK_ID"]).cards : Card.all
  end

  desc "Make cards due today, keeping their SM-2 progress (optional DECK_ID=1)"
  task reset_due: :environment do
    count = study_cards.update_all(next_review_date: Date.current, updated_at: Time.current)

    puts "#{count} card(s) are now due today (#{Date.current}). SM-2 progress was kept."
  end

  desc "Reset cards to new-card SM-2 values and make them due today (optional DECK_ID=1)"
  task reset: :environment do
    count = study_cards.update_all(
      repetition: 0,
      interval: 0,
      ease_factor: 2.5,
      next_review_date: Date.current,
      updated_at: Time.current
    )

    puts "#{count} card(s) were reset to new cards and are due today (#{Date.current})."
  end

  desc "Add one review per day for the past DAYS days (default 3) to test study streaks (optional DECK_ID=1)"
  task backfill_streak: :environment do
    days = ENV.fetch("DAYS", "3").to_i
    abort "DAYS must be 1 or more." if days < 1

    decks = study_cards.includes(:deck).map(&:deck).uniq

    decks.each do |deck|
      card = deck.cards.order(:id).first

      (1..days).each do |days_ago|
        date = Date.current - days_ago.days
        next if deck.reviews.exists?(reviewed_on: date)

        card.reviews.create!(quality: Card::RATINGS["good"], reviewed_on: date)
      end

      puts "#{deck.name}: study streak is now #{deck.current_streak} day(s)."
    end
  end
end
