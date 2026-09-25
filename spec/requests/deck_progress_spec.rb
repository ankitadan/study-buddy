require "rails_helper"

RSpec.describe "Deck Progress", type: :request do
  let!(:deck) { Deck.create!(name: "Spanish") }

  def page
    Nokogiri::HTML(response.body)
  end

  it "shows zero progress and empty states for a new deck" do
    get deck_progress_path(deck)

    expect(response).to have_http_status(:ok)
    expect(page.at_css(".stat-tiles").text.squish)
      .to eq("Due today 0 Total reviews 0 Current streak 0 days Longest streak 0 days")
    expect(response.body).to include("No active streak.")
    expect(response.body).to include("This deck does not have any cards yet.")
    expect(page.css(".milestone")).to be_empty
    expect(page.at_css(".milestone-next").text.squish).to eq("3 more days of studying to reach a 3-day streak.")
    expect(response.body).not_to include("Locked")
  end

  it "shows an active streak, earned badges, and the next milestone" do
    card = deck.cards.create!(question: "Hello", answer: "Hola")
    (0..3).each { |days_ago| card.reviews.create!(quality: 4, reviewed_on: Date.current - days_ago.days) }

    get deck_progress_path(deck)

    expect(page.at_css(".streak-active").text).to include("4-day streak!")
    expect(page.css(".milestone").map { |badge| badge.text.squish }).to eq([ "🏅 3-day streak" ])
    expect(page.at_css(".milestone-next").text.squish).to eq("3 more days of studying to reach a 7-day streak.")
  end

  it "warns when the streak is at risk" do
    card = deck.cards.create!(question: "Hello", answer: "Hola")
    card.reviews.create!(quality: 4, reviewed_on: Date.current - 1.day)

    get deck_progress_path(deck)

    expect(page.at_css(".streak-at_risk").text).to include("Study today to keep your 1-day streak!")
    expect(page.at_css(".streak-at_risk a")["href"]).to eq(deck_study_session_path(deck))
  end

  it "shows mastery as one bar from New through Learning to Mastered" do
    deck.cards.create!(question: "New", answer: "a")
    deck.cards.create!(question: "Mastered", answer: "a", repetition: 4, interval: 38)

    get deck_progress_path(deck)

    bar = page.at_css(".mastery-journey")
    expect(bar["aria-valuenow"]).to eq("50")
    expect(bar.at_css(".journey-remaining")["style"]).to eq("width: 50%")
    expect(bar.at_css(".mastery-stages").text.squish).to eq("New 1 Learning 0 Mastered 1")
    expect(page.at_css(".mastery-summary").text.squish).to eq("50% of the way to mastering this deck.")
    expect(page.at_css(".mastery-pending").text.squish)
      .to eq("1 of 2 cards left to master · about 4 more reviews · at least 22 more days if you keep rating Good")
  end

  it "celebrates when every card is mastered" do
    deck.cards.create!(question: "Mastered", answer: "a", repetition: 4, interval: 38)

    get deck_progress_path(deck)

    expect(page.at_css(".mastery-journey")["aria-valuenow"]).to eq("100")
    expect(response.body).to include("Every card in this deck is mastered!")
    expect(page.at_css(".mastery-pending")).to be_nil
  end

  it "shows the streak goal as a bar toward the next milestone" do
    card = deck.cards.create!(question: "Hello", answer: "Hola")
    (0..1).each { |days_ago| card.reviews.create!(quality: 4, reviewed_on: Date.current - days_ago.days) }

    get deck_progress_path(deck)

    goal = page.css(".journey").first
    expect(goal["aria-valuenow"]).to eq("2")
    expect(goal["aria-valuemax"]).to eq("3")
    expect(goal.at_css(".streak-fill")["style"]).to eq("width: 66%")
    expect(goal.at_css(".journey-labels").text.squish).to eq("Day 2 🏅 3-day streak")
  end

  it "shows this week from Monday to Sunday with studied days" do
    card = deck.cards.create!(question: "Hello", answer: "Hola")
    2.times { card.reviews.create!(quality: 4, reviewed_on: Date.current) }

    get deck_progress_path(deck)

    days = page.css(".week-day")
    expect(days.map { |day| day.at_css(".week-day-label").text }).to eq(%w[M T W Th F S S])

    today = page.at_css(".week-day-today")
    expect(today["class"]).to include("week-day-studied")
    expect(today["title"]).to eq("#{Date.current.to_fs(:review)}: 2 reviews")
    expect(today.at_css(".week-day-count").text.strip).to eq("2")
    expect(response.body).to include("Studied 1 of 7 days this week.")
  end

  it "returns not found for a missing deck" do
    get "/decks/999999/progress"

    expect(response).to have_http_status(:not_found)
  end

  it "is linked from the decks page and the deck page" do
    get decks_path
    expect(response.body).to include(deck_progress_path(deck))

    get deck_path(deck)
    expect(response.body).to include(deck_progress_path(deck))
  end
end
