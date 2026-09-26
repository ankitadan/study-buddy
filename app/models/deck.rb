class Deck < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :reviews, through: :cards

  validates :name, presence: true, uniqueness: true

  def due_cards_count
    cards.due.count
  end

  def reviews_count
    reviews.count
  end

  # Consecutive days with at least one review, ending today. A streak is not
  # broken until a full day passes without studying, so it still counts from
  # yesterday if the learner has not studied yet today.
  def current_streak(today = Date.current)
    DeckProgress.new(self, today: today).current_streak
  end
end
