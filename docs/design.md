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

The current application contains two primary models.

### Deck

The `Deck` model stores:

* `name`
* `description`
* `created_at`
* `updated_at`

A deck has many cards:

```ruby
has_many :cards, dependent: :destroy
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

## Planned Spaced-Repetition Design

The overall project is designed to support spaced-repetition learning using the SM-2 algorithm. This functionality is planned to build on the current Deck and Card structure.

When scheduling functionality is implemented, the `Card` model can be extended with fields such as:

* `repetition` — number of successful reviews
* `interval` — number of days until the next review
* `ease_factor` — factor used to calculate future intervals
* `next_review_date` — date on which the card becomes due

Review history can also be stored separately so that previous study sessions can be used for progress statistics.

These fields are part of the planned scheduling design and are not currently part of the implemented Card model.

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

### Future Study Workflow

The planned study workflow is:

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

Future study functionality will also handle:

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

Spaced-repetition scheduling, study sessions, progress statistics, CSV import/export, and quiz mode are designed as future or optional functionality. This allows the team to prioritize a working core application while leaving room for additional features as development continues.

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

The design also provides a planned foundation for spaced-repetition study functionality using SM-2 and future progress-tracking features.
