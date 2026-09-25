# Summarizes the reviews a learner made during one study session.
class StudySessionSummary
  attr_reader :deck, :reviews

  def initialize(deck, review_ids)
    @deck = deck
    @reviews = deck.reviews.where(id: review_ids)
  end

  def reviewed_count
    reviews.size
  end

  def rating_counts
    counts = reviews.group(:quality).count

    Card::RATINGS.transform_values { |quality| counts.fetch(quality, 0) }
  end

  # Hard, Good, and Easy count as remembered; Again does not.
  def remembered_percentage
    return 0 if reviewed_count.zero?

    (reviews.count { |review| review.quality >= 3 } * 100.0 / reviewed_count).round
  end

  def next_review_date
    deck.cards.minimum(:next_review_date)
  end

  def progress
    @progress ||= DeckProgress.new(deck)
  end
end
