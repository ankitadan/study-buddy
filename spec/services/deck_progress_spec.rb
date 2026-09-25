require "rails_helper"

RSpec.describe DeckProgress do
  let(:deck) { Deck.create!(name: "Spanish") }
  let(:card) { deck.cards.create!(question: "Hello", answer: "Hola") }
  let(:today) { Date.new(2026, 9, 25) } # a Friday
  let(:progress) { described_class.new(deck, today: today) }

  def review_on(date, count: 1, reviewed_card: card)
    count.times { reviewed_card.reviews.create!(quality: 4, reviewed_on: date) }
  end

  describe "empty deck" do
    it "returns zeros and no streak" do
      expect(progress.due_count).to eq(0)
      expect(progress.reviews_count).to eq(0)
      expect(progress.current_streak).to eq(0)
      expect(progress.longest_streak).to eq(0)
      expect(progress.streak_status).to eq(:none)
      expect(progress.earned_milestones).to be_empty
      expect(progress.mastery).to eq(new: 0, learning: 0, mastered: 0)
      expect(progress.mastery_percentages).to eq(new: 0, learning: 0, mastered: 0)
    end
  end

  describe "#mastery" do
    it "groups cards into new, learning, and mastered by SM-2 interval" do
      deck.cards.create!(question: "New", answer: "a")
      deck.cards.create!(question: "Learning", answer: "a", interval: 6)
      deck.cards.create!(question: "Almost", answer: "a", interval: 20)
      deck.cards.create!(question: "Mastered", answer: "a", interval: 21)

      expect(progress.mastery).to eq(new: 1, learning: 2, mastered: 1)
      expect(progress.mastery_percentages).to eq(new: 25, learning: 50, mastered: 25)
    end

    it "counts a card rated Again as learning" do
      card.review(Card::RATINGS["again"])

      expect(progress.mastery).to eq(new: 0, learning: 1, mastered: 0)
    end
  end

  describe "mastery progress" do
    it "is 0% with four Good reviews and 22 days left for a new card" do
      card

      expect(progress.mastery_progress_percentage).to eq(0)
      expect(progress.cards_to_master).to eq(1)
      expect(progress.reviews_to_mastery).to eq(4)
      expect(progress.days_to_mastery).to eq(22)
    end

    it "moves a card through Learning with each Good review" do
      card.review(Card::RATINGS["good"])
      expect(described_class.new(deck, today: Date.current)).to have_attributes(
        mastery_progress_percentage: 43, reviews_to_mastery: 3, days_to_mastery: 22
      )

      card.review(Card::RATINGS["good"])
      expect(described_class.new(deck, today: Date.current)).to have_attributes(
        mastery_progress_percentage: 62, reviews_to_mastery: 2
      )
    end

    it "puts a card rated Again at the start of Learning" do
      card.review(Card::RATINGS["again"])

      expect(described_class.new(deck, today: Date.current).mastery_progress_percentage).to eq(25)
    end

    it "is 100% with nothing left when every card is mastered" do
      deck.cards.create!(question: "Mastered", answer: "a", repetition: 4, interval: 38)

      expect(progress).to have_attributes(
        mastery_progress_percentage: 100, cards_to_master: 0, reviews_to_mastery: 0, days_to_mastery: 0
      )
    end

    it "averages the cards and uses the slowest card for days left" do
      card
      deck.cards.create!(question: "Mastered", answer: "a", repetition: 4, interval: 38)

      expect(progress.mastery_progress_percentage).to eq(50)
      expect(progress.days_to_mastery).to eq(22)
    end

    it "does not save the simulated reviews" do
      expect { progress.reviews_to_mastery }.not_to change { card.reload.attributes }
    end
  end

  describe "#streak_goal_percentage" do
    it "fills toward the next milestone" do
      review_on(today)
      review_on(today - 1.day)

      expect(progress.streak_goal_percentage).to eq(66)
    end

    it "is full after the last milestone" do
      (0..30).each { |days_ago| review_on(today - days_ago.days) }

      expect(progress.streak_goal_percentage).to eq(100)
    end
  end

  describe "#streak_status" do
    it "is active after studying today" do
      review_on(today)

      expect(progress.streak_status).to eq(:active)
    end

    it "is at risk after studying yesterday but not today" do
      review_on(today - 1.day)

      expect(progress.streak_status).to eq(:at_risk)
      expect(progress.current_streak).to eq(1)
    end

    it "is none after missing a full day" do
      review_on(today - 2.days)

      expect(progress.streak_status).to eq(:none)
    end
  end

  describe "#longest_streak" do
    it "finds the longest run of consecutive study days" do
      review_on(today - 10.days)
      review_on(today - 9.days)
      review_on(today - 8.days)
      review_on(today - 7.days)
      review_on(today - 1.day)
      review_on(today)

      expect(progress.longest_streak).to eq(4)
      expect(progress.current_streak).to eq(2)
    end
  end

  describe "#earned_milestones" do
    it "earns badges from the longest streak and keeps them after a streak ends" do
      (3..9).each { |days_ago| review_on(today - days_ago.days) } # 7-day streak that ended

      expect(progress.earned_milestones).to eq([ 3, 7 ])
      expect(progress.current_streak).to eq(0)
    end

    it "reports the next milestone for the current streak" do
      review_on(today)
      review_on(today - 1.day)

      expect(progress.next_milestone).to eq(3)
      expect(progress.days_to_next_milestone).to eq(1)
    end

    it "has no next milestone after passing the last one" do
      (0..30).each { |days_ago| review_on(today - days_ago.days) }

      expect(progress.next_milestone).to be_nil
      expect(progress.earned_milestones).to eq(DeckProgress::MILESTONES)
    end
  end

  describe "#this_week" do
    it "returns Monday to Sunday of the current week" do
      week = progress.this_week

      expect(week.map(&:label)).to eq(%w[M T W Th F S S])
      expect(week.first.date).to eq(Date.new(2026, 9, 21))
      expect(week.first.date).to be_monday
      expect(week.last.date).to eq(Date.new(2026, 9, 27))
    end

    it "marks today and the days after it" do
      week = progress.this_week.index_by(&:date)

      expect(week[today].today).to be(true)
      expect(week[today].future).to be(false)
      expect(week[today + 1.day].future).to be(true)
      expect(week[today - 1.day].future).to be(false)
    end

    it "counts reviews per day this week" do
      review_on(today, count: 2)
      review_on(today - 3.days)
      review_on(today - 7.days) # last week

      week = progress.this_week.index_by(&:date)

      expect(week[today].count).to eq(2)
      expect(week[today - 3.days]).to be_studied
      expect(week[today - 1.day]).not_to be_studied
      expect(progress.days_studied_this_week).to eq(2)
    end

    it "ignores reviews from other decks" do
      other_card = Deck.create!(name: "French").cards.create!(question: "Bonjour", answer: "Hi")
      review_on(today, reviewed_card: other_card)

      expect(progress.days_studied_this_week).to eq(0)
    end
  end
end
