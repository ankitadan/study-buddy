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

### User Story 6: Prevent Invalid Deck Information

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
| 6     | Prevent Invalid Deck Information | Sad Path / Error Handling |

## Card Management

### User Story 1: Create a Card

**As a student, I want to add cards to my study deck with a question and answer so that I can create study material for the selected topic.**

**Acceptance Criteria:**

* The user can open the Create a New Card page from a deck.
* The user can enter a question and answer.
* The question cannot be blank.
* The answer cannot be blank.
* Submitting valid information creates and saves a card.
* The card is associated with the selected deck.
* The user is redirected back to the deck after creation.
* The card appears under the correct deck.

### User Story 2: View/Navigate Through Cards

**As a student, I want to navigate forward and backward through the cards so that I can study every card in the deck.**

**Acceptance Criteria:**

* The user can open a deck's detail page.
* The first card is displayed by default.
* Only one card is displayed at a time.
* The displayed card includes its question and answer.
* Cards from other decks are not displayed.
* The user can click Next Card to view the next card.
* The user can click Previous Card to view the previous card.
* Cards are displayed in a consistent order.
* Navigation remains within the selected deck.
* The first card does not display a previous-card option.
* The last card does not display a next-card option.
* The correct question and answer are displayed after navigation.
* If the deck has no cards, an informative message is shown.
* The user can access the option to add a new card.

### User Story 3: Add a Card While Viewing Cards

**As a student, I want to add a new card while viewing a deck so that I can expand my study material whenever needed.**

**Acceptance Criteria:**

* An Add New Card button is visible on the deck page.
* The user can open the card creation form from the deck page.
* The new card is automatically associated with the current deck.
* The user must provide both a question and answer.
* After saving, the user returns to the deck workflow.
* The newly created card is available when navigating through the deck.

### User Story 4: Delete a Deck and Its Cards

**As a student, I want all cards to be deleted when I delete a deck so that no orphaned cards remain in the application.**

**Acceptance Criteria:**

* The user can delete an existing deck.
* The deck is removed from the application.
* All cards associated with that deck are also deleted.
* Cards belonging to other decks are not affected.
* The user is redirected to the decks page after deletion.
* The deleted deck and its cards cannot be accessed afterward.

### User Story 5: Edit/Update a Card

**As a student, I want to edit a card's question and answer so that I can correct or update my study material.**

**Acceptance Criteria:**

* The user can click Edit for an existing card.
* The edit form displays the current question and answer.
* The user can update the question.
* The user can update the answer.
* The card remains associated with the same deck.
* Blank questions or answers are rejected.
* Invalid updates do not overwrite the existing card information.
* After a successful update, the user returns to the deck page.

### User Story 6: Delete a Card Without Affecting Card Order

**As a student, I want to delete a card without changing the relative order of the remaining cards so that I can continue studying in a predictable sequence.**

**Acceptance Criteria:**

* The user can delete the currently displayed card.
* The card is removed from the selected deck.
* The remaining cards keep their original relative order.
* Cards from other decks are not affected.
* The user can continue navigating through the remaining cards.
* If the deleted card was the first or last card, navigation still works correctly.
* If no cards remain, the deck displays an informative empty-state message.
* Deleting a card does not delete the deck or any other cards.

| Story | Feature                               | Classification |
| ----- | ------------------------------------- | -------------- |
| 1     | Create a Card                         | Essential      |
| 2     | View/Navigate Through Cards           | Essential      |
| 3     | Add a Card While Viewing Cards        | Essential      |
| 4     | Delete a Deck and Its Cards           | Essential      |
| 5     | Edit a Card                           | Essential      |
| 6     | Delete a Card Without Affecting Order | Essential      |

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
