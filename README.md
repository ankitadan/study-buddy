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
* Optional CSV import/export and quiz mode

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

## Tests

Run the full RSpec test suite:

```bash
bundle exec rspec
```

Run style checks with RuboCop:

```bash
bundle exec rubocop
```

## Scheduling Note

The project originally described a Leitner box system. The implemented design uses SM-2 instead.

Study ratings are mapped to quality scores:

* **Again = 0**
* **Hard = 3**
* **Good = 4**
* **Easy = 5**

The SM-2 algorithm uses these ratings to update each card's repetition count, interval, ease factor, and next review date. The ease factor is never allowed to fall below 1.3.

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
