# StudyBuddy

StudyBuddy is a Ruby on Rails flashcard application for organizing study material and reviewing cards using the SM-2 spaced-repetition algorithm. Learners can create decks, manage cards, study cards that are due, self-grade their recall, and view basic progress.

## Team

* Tanvi Patel
* Ankita Dan

## Main Features

* Deck and card CRUD
* Question and answer validation
* Due-card study sessions
* Again, Hard, Good, and Easy self-grading
* SM-2 scheduling using intervals, repetitions, ease factor, and next review dates
* Progress statistics and study streaks
* CSV import/export and optional quiz mode

## Technologies Used

* Ruby
* Ruby on Rails
* SQLite
* RSpec
* HTML/ERB
* CSS
* RuboCop

## Requirements

Before setting up the application, make sure you have:

* Ruby
* Bundler
* Rails
* Git

## Setup

Clone the repository and navigate to the project directory:

```bash
git clone https://github.com/ankitadan/study-buddy.git
cd study-buddy
```

Install the required dependencies:

```bash
bundle install
```

Set up the database:

```bash
bin/rails db:setup
```

## Running the Application

Start the Rails server:

```bash
bin/rails server
```

Open the application in a browser at:

`http://localhost:3000`

To stop the server, press `Ctrl + C`.

## Studying Due Cards

1. Open a deck and click **Study Due Cards**. The link shows how many cards are due.
2. Read the question, then click **Show Answer**.
3. Grade yourself with **Again**, **Hard**, **Good**, or **Easy**.
4. SM-2 schedules the card's next review, the card leaves the queue, and the next due card appears. A message shows the date SM-2 picked, for example "Next review of "Hello" is September 26, 2026 (in 1 day)."
5. When every due card has been graded, the page shows "No cards are due for review."

A card is due when its `next_review_date` is today or earlier. The most overdue cards are shown first.

Each card's page (and the card list) also shows its SM-2 state: next review date, interval, number of successful reviews, and ease factor.

## Progress

The decks page (`/decks`) shows progress for each deck:

* **Due today:** cards that are due now
* **Total reviews:** how many times cards in the deck have been graded
* **Study streak:** consecutive days with at least one review in the deck. The streak still counts from yesterday if you haven't studied yet today, and resets after a missed day.

New decks show zeros. Every grade in a study session is saved as a review, and progress is calculated from those reviews.

Click **View Progress** on a deck for its progress page (`/decks/:id/progress`). It shows:

* **Streak status:** 🔥 when you've studied today, or a reminder to "Study today to keep your streak!" when you studied yesterday but not yet today
* **Stats:** due today, total reviews, current streak, and longest streak
* **Streak goal:** a bar that fills toward your next milestone (3, 7, 14, or 30 days in a row), with your earned 🏅 badges
* **Mastery:** one bar for the deck from New → Learning → Mastered, with how many cards are in each stage and what's left: cards to master, about how many more reviews, and at least how many more days if you keep rating Good. A card is Mastered once SM-2 schedules it 21 or more days away.
* **This week:** a Monday-to-Sunday strip (M T W Th F S S) showing which days you studied and how many cards

When you finish every due card in a study session, a **Session complete!** summary shows how many cards you reviewed, the percentage you remembered, your streak, and your ratings.

Studying several times on the same day still counts as one streak day, and `study:reset` does not change review history. To test longer streaks without waiting, add past-day reviews in development:

```bash
bin/rails study:backfill_streak              # one review per day for the past 3 days, every deck with cards
bin/rails study:backfill_streak DAYS=5 DECK_ID=1
```

Study once today afterwards and the streak becomes DAYS + 1. The task skips days that already have a review, so running it twice does not add duplicates. It refuses to run in production.

### Making cards due again for testing

After a study session, the graded cards are scheduled for a later date. Two tasks make them due again:

```bash
bin/rails study:reset                  # start over: every card becomes a brand-new card, due today
bin/rails study:reset_due              # keep SM-2 progress, only make every card due today
bin/rails study:reset DECK_ID=1        # either task can be limited to one deck
```

Use `study:reset` when you want to compare ratings. It sets `repetition = 0`, `interval = 0`, `ease_factor = 2.5`, and `next_review_date = today`.

`study:reset_due` keeps each card's repetitions, interval, and ease factor, so studying again acts as if the right number of days had passed. Intervals grow quickly this way: a card rated Good five times in a row is scheduled 95 days out. Both tasks refuse to run in production.

Expected intervals for a new card rated the same way every time:

| Rating | 1st | 2nd | 3rd | 4th | 5th |
| ------ | --: | --: | --: | --: | --: |
| Hard   | 1d  | 6d  | 12d | 23d | 41d  |
| Good   | 1d  | 6d  | 15d | 38d | 95d  |
| Easy   | 1d  | 6d  | 17d | 49d | 147d |

Again always schedules the card for tomorrow and restarts its sequence. The first two successful reviews are 1 and 6 days for every passing rating, as defined by SM-2.

## Troubleshooting

### `db:migrate` fails with "duplicate column name: repetition"

This happens when your local database already has the SM-2 columns from an older, uncommitted migration, but Rails has no record of `20260924204501_add_sm2_fields_to_cards` being run. Check with:

```bash
bin/rails db:migrate:status
```

If the old versions show `NO FILE` and the SM-2 migration shows `down`, the simplest fix is to rebuild the development database. **This deletes your local decks and cards:**

```bash
bin/rails db:reset
```

To keep your local data instead, record the migration as already applied and make the column match `db/schema.rb`:

```bash
bin/rails runner "ActiveRecord::Base.connection.execute(%q{INSERT INTO schema_migrations (version) VALUES ('20260924204501')})"
bin/rails runner "c = ActiveRecord::Base.connection; c.change_column_null(:cards, :next_review_date, true); c.change_column_default(:cards, :next_review_date, nil)"
bin/rails db:migrate
```

Afterwards, `git diff db/schema.rb` should show no changes.

### `Could not find csv-3.3.6 in locally installed gems`

Run `bundle install` after pulling changes that update `Gemfile.lock`.

## Known Limitations

* The first release supports one local application database and does not include user accounts.
* Progress analytics are intentionally basic.
* CSV import/export and quiz mode are stretch features and may not be included in the core release.
* The application is primarily configured for local development and testing.

## Project Documentation

* [User Stories](docs/user_stories.md)
* [Testing Plan](docs/testing.md)
* [Design](docs/design.md)
* [Backlog](docs/backlog.md)
* [Planning](docs/planning.md)
* [Pairing Log](docs/pairing_log.md)
* [Project Practices](docs/project_practices.md)
* [Retrospective](docs/retrospective.md)
