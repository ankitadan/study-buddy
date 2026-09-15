# StudyBuddy User Stories

StudyBuddy is a Rails flashcard app that uses the SM-2 spaced-repetition algorithm to schedule reviews.

## Essential stories

## Deck Management

### User Story 1: Create a Deck

**As a student, I want to create a study deck with a name and description so that I can organize my study material by topic.**

**Acceptance Criteria:**

* The user can open the "Create a New Deck" page.
* The user can enter a deck name and description.
* Submitting the form creates and saves a new deck.
* The user is redirected to the newly created deck.

---

### User Story 2: View My Decks

**As a student, I want to view my study decks so that I can choose which deck I want to study.**

**Acceptance Criteria:**

* The user can access the Decks page.
* The page loads successfully.
* Existing decks are displayed.
* Each deck displays its name and description.

---

### User Story 3: View a Deck

**As a student, I want to view an individual deck so that I can see its details and manage its study cards.**

**Acceptance Criteria:**

* The user can open an existing deck.
* The deck name and description are displayed.
* The user can access the option to add a new card.
* The user can access the option to delete the deck.

---

### User Story 4: Edit a Deck

**As a student, I want to edit my deck's name and description so that I can keep my study materials up to date.**

**Acceptance Criteria:**

* The user can access the edit page for an existing deck.
* The current deck information is displayed.
* The user can change the deck name and description.
* The updated information is saved.
* The user is redirected to the updated deck.

---

### User Story 5: Delete a Deck

**As a student, I want to delete a deck that I no longer need so that I can keep my study materials organized.**

**Acceptance Criteria:**

* The user can delete an existing deck.
* The deck is removed from the application.
* The user is redirected to the Decks page after deletion.

---

### User Story 6: Manage Cards Within a Deck

**As a student, I want to associate multiple study cards with a deck so that I can organize related questions and answers together.**

**Acceptance Criteria:**

* A deck can contain multiple cards.
* Each card belongs to its associated deck.
* The user can access card management from a deck.
* When a deck is deleted, its associated cards are also deleted.

---

### User Story 7: Prevent Invalid Deck Information

**As a student, I want the application to prevent me from saving a deck without a name so that all of my study decks can be clearly identified.**

**Acceptance Criteria:**

* A deck must have a name.
* The user cannot create a deck with an empty name.
* The user cannot update a deck with an empty name.
* Invalid information is not saved.
* The existing deck information remains unchanged when an invalid update is submitted.
* The user receives an appropriate error response when invalid information is submitted.

---

## Story Classification

| Story | Feature                          | Classification            |
| ----- | -------------------------------- | ------------------------- |
| 1     | Create a Deck                    | Essential                 |
| 2     | View My Decks                    | Essential                 |
| 3     | View a Deck                      | Essential                 |
| 4     | Edit a Deck                      | Essential                 |
| 5     | Delete a Deck                    | Essential                 |
| 6     | Manage Cards Within a Deck       | Essential                 |
| 7     | Prevent Invalid Deck Information | Sad Path / Error Handling |

## Testing

These user stories are supported by automated tests using RSpec.

The test suite includes:

* Unit tests for Deck model behavior and associations.
* Request/acceptance tests for user-facing Deck functionality.
* Happy-path tests for valid Deck creation, viewing, editing, and deletion.
* Sad-path tests for invalid Deck creation and updates.

The test suite can be run from the project root using:

```bash
bundle exec rspec
```


### US-2: Manage cards

As a learner, I want to add, edit, and delete cards inside a deck so that I can manage study material.

**Acceptance criteria**

- A card belongs to one selected deck.
- Each card has a question and answer.
- Question and answer cannot be blank.
- Cards are displayed under the correct deck.
- A learner can edit or delete an existing card.

### US-3: Study due cards

As a learner, I want to study cards that are due so that my review session focuses on the material I need now.

**Acceptance criteria**

- A study session displays cards whose `next_review_date` is today or earlier.
- The learner can reveal the answer after seeing the question.
- A card is removed from the current queue after it is graded.
- A clear message appears when no cards are due.

### US-4: Schedule reviews with SM-2

As a learner, I want my self-assessment to schedule the next review so that difficult cards return sooner and well-known cards return later.

**Acceptance criteria**

- The learner can choose Again, Hard, Good, or Easy.
- The application maps each choice to an SM-2 quality score.
- SM-2 updates the card's repetition count, interval, ease factor, and next review date.
- A failed review resets the repetition sequence and schedules the card soon.
- The ease factor never falls below 1.3.

### US-5: View progress

As a learner, I want to see review and mastery statistics so that I can understand my progress.

**Acceptance criteria**

- The app shows cards due today and total cards reviewed.
- The app shows a simple current study streak.
- Empty data produces zeros or an informative empty state instead of an error.

## Optional stories

### US-6: Import and export decks

As a learner, I want to import and export decks as CSV files so that I can reuse study material.

**Acceptance criteria**

- A valid CSV can create a deck and its cards.
- Invalid rows are reported without crashing the application.
- A deck can be exported with its questions and answers.

### US-7: Quiz mode

As a learner, I want an optional quiz mode so that I can practice answering cards without immediately seeing the answer.

**Acceptance criteria**

- The learner can start a quiz from a selected deck.
- The learner can mark an answer correct or incorrect.
- The quiz shows a final score and does not change SM-2 scheduling unless explicitly chosen.

### US-8: Handle invalid input

As a learner, I want invalid input to produce a helpful message so that I can correct it without losing my progress.

**Acceptance criteria**

- Blank deck, question, and answer fields are rejected.
- An invalid review choice causes a re-prompt or validation message.
- Invalid CSV data is handled gracefully.
- Normal invalid input does not crash the app.
