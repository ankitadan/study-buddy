# StudyBuddy Design

## Architecture

StudyBuddy is a Ruby on Rails application that follows the Model-View-Controller (MVC) architecture. The current implementation focuses on deck and card management. The application uses models to represent decks and cards, controllers to handle user requests, and views to provide the user interface.

| Component         | Responsibility                                                                  |
| ----------------- | ------------------------------------------------------------------------------- |
| `Deck` model      | Stores the deck name and description and manages its relationship with cards.   |
| `Card` model      | Stores the question and answer for a flashcard and belongs to a deck.           |
| `DecksController` | Handles creating, viewing, editing, updating, and deleting decks.               |
| `CardsController` | Handles creating, viewing, editing, updating, and deleting cards within a deck. |
| Views             | Provide the user interface for managing decks and cards.                        |
| Database          | Persists decks and cards and maintains the relationship between them.           |

### System Interactions

The main deck-management flow is:

1. A learner opens the Decks page.
2. The application displays the available decks.
3. The learner can create a new deck.
4. The learner can select a deck to view its details.
5. The learner can edit or delete the deck.
6. From a deck's detail page, the learner can add and manage cards.

The card-management flow is:

1. A learner selects a deck.
2. The application displays the cards belonging to that deck.
3. The learner can create a new card by entering a question and answer.
4. The learner can view or edit an existing card.
5. The learner can delete a card when it is no longer needed.

Cards are associated with their parent deck through `deck_id`. Deleting a deck also deletes its associated cards.

## Data Model

The current application contains three models: `Deck`, `Card`, and `Review`.

### Deck

The `Deck` model stores:

* `name`
* `description`
* `created_at`
* `updated_at`

A deck has many cards:

```ruby
has_many :cards, dependent: :destroy
has_many :reviews, through: :cards
```

The `dependent: :destroy` relationship ensures that cards associated with a deck are removed when the deck is deleted.

### Card

The `Card` model currently stores:

* `question`
* `answer`
* `deck_id`
* `created_at`
* `updated_at`

A card belongs to one deck:

```ruby
belongs_to :deck
```

The question and answer fields are required, so a card cannot be created without both pieces of information.

A card also has many reviews, which are deleted with the card.

### Review

The `Review` model records each time a learner grades a card in a study session:

* `card_id`
* `quality` — SM-2 quality score (0, 3, 4, or 5)
* `reviewed_on` — date of the review
* `created_at`
* `updated_at`

Reviews are the source for progress statistics. The card's SM-2 fields describe only its current schedule, so review history is kept separately.

## Planned Spaced-Repetition Design

The overall project is designed to support spaced-repetition learning using the SM-2 algorithm. This functionality is planned to build on the current Deck and Card structure.

When scheduling functionality is implemented, the `Card` model can be extended with fields such as:

* `repetition` — number of successful reviews
* `interval` — number of days until the next review
* `ease_factor` — factor used to calculate future intervals
* `next_review_date` — date on which the card becomes due

Review history is stored separately in the `Review` model so that previous study sessions can be used for progress statistics.

These fields are now part of the Card model. New cards start with `repetition = 0`, `interval = 0`, `ease_factor = 2.5`, and `next_review_date = today`, so they are due immediately.

## SM-2 Design Decision

The project originally described a Leitner box system. The planned implementation uses SM-2 instead.

SM-2 was selected because it can adjust the review interval based on how well the learner remembers a card, allowing the system to provide more personalized review scheduling.

The planned interface uses learner-friendly ratings:

| Rating | Quality | Intended Meaning                       |
| ------ | ------: | -------------------------------------- |
| Again  |       0 | Did not remember the answer            |
| Hard   |       3 | Remembered with significant difficulty |
| Good   |       4 | Remembered with normal effort          |
| Easy   |       5 | Remembered easily and confidently      |

For quality below 3, the card's review sequence would be reset and the card would be scheduled for a short retry. For successful reviews, SM-2 would calculate increasingly longer intervals.

The project will describe scheduling using intervals, repetitions, ease factor, and due dates rather than numbered Leitner boxes.

## UI Design

The application uses a simple web interface focused on deck and card management.

### Decks Page

```text
+------------------------------------------+
|                 StudyBuddy               |
|------------------------------------------|
| My Decks                                 |
|                                          |
| Java                                     |
| Programming for Web Dev                  |
| [View Deck]       [Delete]               |
|                                          |
| Data Structures                          |
| Algorithms and data structures           |
| [View Deck]       [Delete]               |
|                                          |
|             [Create New Deck]             |
+------------------------------------------+
```

The learner can view existing decks, open a deck, delete a deck, or create a new deck.

### Deck Detail Page

```text
+------------------------------------------+
| Java                                     |
| Programming for Web Dev                  |
|------------------------------------------|
|                                          |
| [Add New Card]                           |
|                                          |
| What is inheritance?                     |
| [Show]             [Edit]                |
|                                          |
| What is polymorphism?                    |
| [Show]             [Edit]                |
|                                          |
| [Back to My Decks]                       |
| [Delete This Deck]                       |
+------------------------------------------+
```

The deck detail page displays the deck information and its cards. It also provides actions for adding and managing cards.

### New/Edit Deck Page

```text
+------------------------------------------+
|             Create a New Deck            |
|------------------------------------------|
| Name:                                    |
| [____________________________]            |
|                                          |
| Description:                             |
| [____________________________]            |
| [____________________________]            |
|                                          |
|              [Save Deck]                  |
+------------------------------------------+
```

The same general form is used when editing an existing deck.

### New/Edit Card Page

```text
+------------------------------------------+
|                New Card                  |
|------------------------------------------|
| Question:                                |
| [____________________________]            |
| [____________________________]            |
|                                          |
| Answer:                                  |
| [____________________________]            |
| [____________________________]            |
|                                          |
|              [Save Card]                  |
+------------------------------------------+
```

The card form requires both a question and an answer.

## UI Workflows

### Deck Management

```text
Decks Index
    |
    +----> Create New Deck
    |          |
    |          v
    |      Save Deck
    |
    v
Deck Detail
    |
    +----> Edit Deck
    |
    +----> Delete Deck
    |
    +----> Manage Cards
```

### Card Management

```text
Deck Detail
    |
    v
Cards
    |
    +----> Add Card
    |
    +----> View Card
    |
    +----> Edit Card
    |
    +----> Delete Card
```

### Study Workflow

The study workflow is:

```text
Select Deck
    |
    v
Find Due Cards
    |
    v
Show Question
    |
    v
Reveal Answer
    |
    v
Choose Rating
    |
    v
Calculate Next Review
    |
    v
Show Next Card
```

## Empty and Invalid States

The application provides feedback for common empty and invalid states.

* **No decks:** The learner is shown an option to create a new deck.
* **No cards in a deck:** The learner is shown an option to add a card.
* **Invalid card:** The learner must provide both a question and an answer.
* **Invalid deck:** The application displays validation errors when required information is missing.
* **Deleting a deck:** The deck and its associated cards are deleted together because of the model relationship.

Study sessions also handle:

* **No cards due:** Display a message indicating that there are no cards to review.
* **No cards in a study session:** Provide an appropriate empty-state message.

## Design Decisions and Tradeoffs

### Rails MVC

The application follows Rails MVC to separate responsibilities.

* **Models** represent application data and relationships.
* **Controllers** handle HTTP requests and coordinate application behavior.
* **Views** render the user interface.

This structure makes the application easier to understand, maintain, and test.

### Deck and Card Relationship

A deck has many cards, while each card belongs to one deck.

This relationship reflects the way learners naturally organize flashcards and allows the application to retrieve cards for a specific deck efficiently.

The `dependent: :destroy` option was selected so that deleting a deck also removes its cards. This prevents cards from being left without a parent deck.

### Validation

Cards require both a question and an answer.

This prevents incomplete flashcards from being stored and provides immediate feedback when a learner submits invalid information.

### SM-2 vs. Leitner

The project originally proposed a Leitner box system, but SM-2 was selected for the planned spaced-repetition functionality.

The main tradeoff is complexity. Leitner is easier to understand and implement because cards move between predefined boxes. SM-2 requires additional scheduling state and calculations, but provides more adaptive review intervals.

### Core Features vs. Future Features

Deck and card management are the current core features because they provide the foundation for the rest of the application.

Spaced-repetition scheduling and study sessions are now implemented on top of deck and card management. Basic per-deck progress statistics are implemented. Expanded analytics and quiz mode remain future or optional functionality. This allows the team to prioritize a working core application while leaving room for additional features as development continues.

## Current Project Scope

The current implementation provides:

* Creating decks
* Viewing decks
* Editing decks
* Deleting decks
* Creating cards within decks
* Viewing cards
* Editing cards
* Deleting cards
* Validating card questions and answers
* Maintaining the relationship between decks and cards
* Deleting associated cards when a deck is deleted
* Scheduling reviews with SM-2 (`Card#review`)
* Study sessions for due cards
* Per-deck progress statistics on the decks page

The design also provides a foundation for future progress-tracking features.

## Study Session Implementation

Study sessions are handled by `StudySessionsController`, a singular resource nested under decks:

| Route                                      | Action   | Purpose                                         |
| ------------------------------------------ | -------- | ----------------------------------------------- |
| `GET /decks/:deck_id/study_session`        | `show`   | Show the next due card; `?reveal=true` shows the answer |
| `POST /decks/:deck_id/study_session/review` | `review` | Grade a card with `card_id` and `rating`        |

* `Card.due` returns cards whose `next_review_date` is today or earlier (or missing), with the most overdue first.
* `Card::RATINGS` maps `again`, `hard`, `good`, and `easy` to SM-2 quality scores 0, 3, 4, and 5.
* The study queue is not stored separately. Grading a card calls `Card#review`, which always moves `next_review_date` at least one day ahead, so the card drops out of `Card.due` automatically.
* The controller rejects unknown ratings, cards that are not due (such as a double-submitted grade), and cards from another deck without changing them.
* `bin/rails study:reset` resets cards to new-card SM-2 values, and `bin/rails study:reset_due` makes cards due today while keeping their SM-2 progress, so the study flow can be tested repeatedly in development.

## Progress Statistics

Progress is shown per deck on the decks page (`/decks`), so learners can see at a glance which decks need attention. Each deck shows:

* **Due today** — `Deck#due_cards_count`, the number of cards whose `next_review_date` is today or earlier.
* **Total reviews** — `Deck#reviews_count`, every grade recorded in the deck. A card graded three times counts three times.
* **Study streak** — `Deck#current_streak`, the number of consecutive days with at least one review in the deck. Several reviews on one day count as one day. The streak still counts from yesterday if the learner has not studied yet today, and it resets to zero once a full day is missed.

Grading a card in a study session updates the card with SM-2 and creates a `Review` in the same transaction, so the schedule and the history stay consistent. Rejected grades create no review.

New decks and decks with no reviews show zeros. When there are no decks, the page shows an empty-state message with a link to create one.

### Deck Progress Page

Each deck has a detailed progress page at `GET /decks/:deck_id/progress` (`DeckProgressController#show`), linked from the decks page and the deck page. The calculations live in the `DeckProgress` service (`app/services/deck_progress.rb`), so controllers and views stay simple and the rules can be unit tested.

The page shows:

* **Streak status** — one of three states:
  * *Active* (🔥): the learner studied today.
  * *At risk* (⏳): the learner studied yesterday but not yet today. The message links straight to the study session.
  * *None*: no current streak.
* **Stat tiles** — due today, total reviews, current streak, and longest streak.
* **Streak goal** — a loading bar that fills toward the next milestone (3, 7, 14, or 30 days), e.g. "Day 2" of a "3-day streak", with the number of days still needed. Earned milestones are shown as 🏅 badges next to it. Badges are earned from the *longest* streak, so they are kept after a streak ends, and badges not yet earned are not shown.
* **Mastery** — one loading bar for the whole deck that runs from **New** on the left, through **Learning**, to **Mastered** on the right, because a card cannot reach Learning without leaving New first:
  * Each card has a progress value. A new card (interval 0) is at 0%. Its first review moves it to the start of Learning at 25%, and it then moves toward 100% as it completes the successful reviews SM-2 needs. A card is Mastered (100%) once its interval is 21 days or more, the "mature" threshold used by Anki.
  * The deck's bar is the average of its cards. The counts of New, Learning, and Mastered cards are shown under the matching part of the bar.
  * Underneath, the page shows what is still pending: cards left to master, about how many more reviews, and at least how many more days, assuming every future review is rated Good. The number of days is set by the slowest card.
  * To estimate this, `DeckProgress` runs Good reviews on an unsaved copy of each card using `Card#schedule` until its interval reaches 21 days. `Card#schedule` holds the unchanged SM-2 calculation; `Card#review` calls it and then saves, so the SM-2 algorithm itself was not changed.
* **This week** — a Monday-to-Sunday strip (M T W Th F S S). Studied days show 🔥 with the number of reviews, today is outlined, and future days are faded. Hovering a day shows its date and review count.

Everything is server-rendered HTML and CSS with no JavaScript, because the project does not load any JavaScript. Hover effects and animations use CSS only and are turned off for users who prefer reduced motion.

### Session-Complete Summary

When the last due card in a session is graded, the study page shows a summary instead of the plain "no cards due" message: the number of cards reviewed, the percentage remembered (Hard, Good, or Easy), the current streak, a breakdown by rating, the next review date in the deck, and a link to the progress page.

To summarize only the current session, `StudySessionsController` stores the IDs of the reviews it creates in the Rails session, keyed by deck and date. The summary (`StudySessionSummary`) is built from those IDs, shown once, and then cleared. An unfinished session from an earlier day is discarded, so an old session is never mixed into today's summary.

