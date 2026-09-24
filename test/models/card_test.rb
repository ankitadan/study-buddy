require "test_helper"

class CardTest < ActiveSupport::TestCase
  test "card requires a question" do
    card = Card.new(answer: "An answer")

    assert_not card.valid?
    assert_includes card.errors[:question], "can't be blank"
  end

  test "card requires an answer" do
    card = Card.new(question: "A question")

    assert_not card.valid?
    assert_includes card.errors[:answer], "can't be blank"
  end

  test "new card has default SM-2 values" do
    card = Card.new

    assert_equal 0, card.repetition
    assert_equal 0, card.interval
    assert_equal 2.5, card.ease_factor
    assert_equal Date.current, card.next_review_date
  end
  test "Again resets repetition and schedules review for tomorrow" do
  card = Card.create!(
    deck: decks(:one),
    question: "Question",
    answer: "Answer"
  )

  card.review(0)

  assert_equal 0, card.repetition
  assert_equal 1, card.interval
  assert_equal Date.current + 1.day, card.next_review_date
end

test "first successful review schedules card for one day" do
  card = Card.create!(
    deck: decks(:one),
    question: "Question",
    answer: "Answer"
  )

  card.review(4)

  assert_equal 1, card.repetition
  assert_equal 1, card.interval
  assert_equal Date.current + 1.day, card.next_review_date
end

test "second successful review schedules card for six days" do
  card = Card.create!(
    deck: decks(:one),
    question: "Question",
    answer: "Answer"
  )

  card.review(4)
  card.review(4)

  assert_equal 2, card.repetition
  assert_equal 6, card.interval
  assert_equal Date.current + 6.days, card.next_review_date
end

test "Good rating keeps the ease factor unchanged" do
  card = Card.create!(
    deck: decks(:one),
    question: "Question",
    answer: "Answer"
  )

  original_ease_factor = card.ease_factor

  card.review(4)

  assert_equal original_ease_factor, card.ease_factor
end

test "Hard rating decreases ease factor" do
  card = Card.create!(
    deck: decks(:one),
    question: "Question",
    answer: "Answer"
  )

  original_ease_factor = card.ease_factor

  card.review(3)

  assert card.ease_factor < original_ease_factor
end
test "Easy rating increases ease factor" do
  card = Card.create!(
    deck: decks(:one),
    question: "Question",
    answer: "Answer"
  )

  original_ease_factor = card.ease_factor

  card.review(5)

  assert card.ease_factor > original_ease_factor
end
end
