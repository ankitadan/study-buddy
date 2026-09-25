class Card < ApplicationRecord
  RATINGS = {
    "again" => 0,
    "hard" => 3,
    "good" => 4,
    "easy" => 5
  }.freeze

  belongs_to :deck

  scope :due, lambda {
    where(next_review_date: nil)
      .or(where(next_review_date: ..Date.current))
      .order(:next_review_date, :id)
  }

  validates :question, presence: true
  validates :answer, presence: true

  after_initialize :set_default_review_date, if: :new_record?

   def review(rating)
    update_ease_factor(rating)

    if rating < 3
      self.repetition = 0
      self.interval = 1
    else
      self.repetition += 1

      self.interval =
        case repetition
        when 1
          1
        when 2
          6
        else
          (interval * ease_factor).round
        end
    end

    self.next_review_date = Date.current + interval.days
    save!
  end

  private

  def update_ease_factor(rating)
    new_ease_factor =
      ease_factor +
      (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02))

    self.ease_factor = [ new_ease_factor, 1.3 ].max
  end

  def set_default_review_date
    self.next_review_date ||= Date.current
  end
end
