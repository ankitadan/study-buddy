class Review < ApplicationRecord
  belongs_to :card

  validates :quality, inclusion: { in: Card::RATINGS.values }
  validates :reviewed_on, presence: true
end
