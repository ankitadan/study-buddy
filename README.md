# StudyBuddy

StudyBuddy is a Rails flashcard application for organizing study material and reviewing cards with the SM-2 spaced-repetition algorithm. Learners create decks, manage cards, study cards that are due, self-grade recall, and view basic progress.

## Team

- Tanvi Patel
- Ankita Dan

## Main features

- Deck and card CRUD
- Question and answer validation
- Due-card study sessions
- Again, Hard, Good, and Easy self-grading
- SM-2 scheduling using intervals, repetitions, ease factor, and next review dates
- Progress statistics and study streaks
- Optional CSV import/export and quiz mode

## Setup

Requirements: Ruby, Bundler, and Rails.

```bash
bundle install
bin/rails db:setup
```

Start the application:

```bash
bin/rails server
```

Open `http://localhost:3000` in a browser.

## Tests and coverage

Run the test suite:

```bash
bundle exec rspec
```

Generate the coverage report:

```bash
COVERAGE=true bundle exec rspec
```

Then open `coverage/index.html`.

Run style checks:

```bash
bundle exec rubocop
```

## Scheduling note

The project originally described a Leitner box system. The implemented design uses SM-2 instead. Review ratings are mapped to quality scores: Again=0, Hard=3, Good=4, and Easy=5. SM-2 updates the card's repetition count, interval, ease factor, and next review date. The ease factor is never allowed below 1.3.

## Known limitations

- The first release supports one local application database and does not include user accounts.
- Progress analytics are intentionally basic.
- CSV import/export and quiz mode are stretch features and may not be included in the core release.

## Project documentation

- [User stories](docs/user_stories.md)
- [Testing plan](docs/testing.md)
- [Design](docs/design.md)
- [Backlog](docs/backlog.md)
- [Planning](docs/planning.md)
- [Pairing log](docs/pairing_log.md)
- [Project practices](docs/project_practices.md)
- [Retrospective](docs/retrospective.md)
