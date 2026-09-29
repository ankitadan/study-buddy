# StudyBuddy User Stories

StudyBuddy is a Ruby on Rails flashcard application that helps students organize study material, review flashcards, and track spaced-repetition information.

## Essential Stories

## Deck Management

### User Story 1: Create a Deck

**As a student, I want to create a study deck with a name and description so that I can organize my study material by topic.**

**Acceptance Criteria:**

* The user can open the "Create a New Deck" page.
* The user can enter a deck name and description.
* Submitting valid information creates and saves a new deck.
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
* The cards belonging to the selected deck are displayed.

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
* Cards associated with the deck are also deleted.
* Cards belonging to other decks are not affected.
* The user is redirected to the Decks page after deletion.

---

### User Story 6: Prevent Invalid Deck Information

**As a student, I want the application to prevent me from saving a deck without a name so that all of my study decks can be clearly identified.**

**Acceptance Criteria:**

* A deck must have a name.
* The user cannot create a deck with an empty name.
* The user cannot update a deck with an empty name.
* Invalid information is not saved.
* Existing deck information remains unchanged when an invalid update is submitted.
* The user receives an appropriate error message when invalid information is submitted.

### Deck Story Classification

| Story | Feature                          | Classification            |
| ----- | -------------------------------- | ------------------------- |
| 1     | Create a Deck                    | Essential                 |
| 2     | View My Decks                    | Essential                 |
| 3     | View a Deck                      | Essential                 |
| 4     | Edit a Deck                      | Essential                 |
| 5     | Delete a Deck                    | Essential                 |
| 6     | Prevent Invalid Deck Information | Sad Path / Error Handling |

---

# Card Management

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

---

### User Story 2: View and Navigate Through Cards

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
* If the deck has no cards, an informative empty-state message is shown.
* The user can access the option to add a new card.

---

### User Story 3: Add a Card While Viewing Cards

**As a student, I want to add a new card while viewing a deck so that I can expand my study material whenever needed.**

**Acceptance Criteria:**

* An Add New Card button is visible on the deck page.
* The user can open the card creation form from the deck page.
* The new card is automatically associated with the current deck.
* The user must provide both a question and answer.
* After saving, the user returns to the deck workflow.
* The newly created card is available when navigating through the deck.

---

### User Story 4: Edit a Card

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

---

### User Story 5: Delete a Card

**As a student, I want to delete a card that I no longer need so that I can keep my study deck organized.**

**Acceptance Criteria:**

* The user can delete an existing card.
* The card is removed from the selected deck.
* The remaining cards are still available.
* Cards from other decks are not affected.
* The user can continue navigating through the remaining cards.
* If no cards remain, an informative empty-state message is displayed.
* Deleting a card does not delete the deck or any other cards.

---

### User Story 6: Delete a Deck and Its Cards

**As a student, I want all cards to be deleted when I delete a deck so that no orphaned cards remain in the application.**

**Acceptance Criteria:**

* The user can delete an existing deck.
* The deck is removed from the application.
* All cards associated with that deck are also deleted.
* Cards belonging to other decks are not affected.
* The user is redirected to the Decks page after deletion.
* The deleted deck and its cards cannot be accessed afterward.

### Card Story Classification

| Story | Feature                        | Classification |
| ----- | ------------------------------ | -------------- |
| 1     | Create a Card                  | Essential      |
| 2     | View/Navigate Through Cards    | Essential      |
| 3     | Add a Card While Viewing Cards | Essential      |
| 4     | Edit a Card                    | Essential      |
| 5     | Delete a Card                  | Essential      |
| 6     | Delete a Deck and Its Cards    | Essential      |

---

# Study and Spaced Repetition

### User Story 1: Study Due Cards

**As a learner, I want to study cards that are due so that my review session focuses on the material I need to review.**

**Acceptance Criteria:**

* A study session can identify cards whose `next_review_date` is today or earlier.
* The learner can see the question before revealing the answer.
* The learner can reveal the answer.
* A graded card is removed from the current review queue.
* A clear message is displayed when there are no cards due for review.

---

### User Story 2: Schedule Reviews with SM-2

**As a learner, I want my self-assessment to schedule the next review so that difficult cards can be reviewed sooner and familiar cards can be reviewed later.**

**Acceptance Criteria:**

* The learner can choose Again, Hard, Good, or Easy.
* Each choice is mapped to an SM-2 quality score.
* The application updates the card's repetition count.
* The application updates the review interval.
* The application updates the ease factor.
* The application calculates the next review date.
* A failed review resets the repetition sequence and schedules the card for earlier review.
* The ease factor cannot fall below 1.3.

---

### User Story 3: Track Study Progress

**As a learner, I want to see study progress information so that I can understand how consistently I am reviewing my cards.**

**Acceptance Criteria:**

* The application can display the number of cards due for review.
* The application can display the number of cards reviewed.
* The application can display a current study streak when review history is available.
* Empty or unavailable progress data produces an appropriate empty state or zero value instead of an error.

### Study Story Classification

| Story | Feature                    | Classification |
| ----- | -------------------------- | -------------- |
| 1     | Study Due Cards            | Essential      |
| 2     | Schedule Reviews with SM-2 | Essential      |
| 3     | Track Study Progress       | Essential      |

---

# CSV Import

### User Story 1: Import Cards from CSV

**As a student, I want to import flashcards from a CSV file so that I can add multiple cards without entering them individually.**

**Acceptance Criteria:**

* The user can upload a CSV file containing flashcard information.
* Valid records are imported into the selected deck.
* Invalid records are skipped.
* Valid records are still imported when the CSV contains both valid and invalid records.
* The user receives a message indicating how many records were not imported.
* Invalid CSV input does not crash the application.

### CSV Story Classification

| Story | Feature               | Classification |
| ----- | --------------------- | -------------- |
| 1     | Import Cards from CSV | Essential      |

---

# Testing

The user stories are supported by automated tests using RSpec.

The test suite includes:

* Model tests for Deck and Card behavior and validations.
* Tests for the Deck/Card relationship.
* Request tests for user-facing Deck and Card functionality.
* Tests for valid deck and card creation, viewing, editing, and deletion.
* Sad-path tests for invalid deck and card submissions.
* Tests for card navigation and empty-deck behavior.
* Tests for CSV import and invalid records.
* Tests related to the spaced-repetition data and behavior.

The test suite can be run from the project root using:

```bash
bundle exec rspec
```

---

# Optional Stories

### User Story 1: Export Decks

**As a learner, I want to export my study cards as a CSV file so that I can reuse my study material outside the application.**

**Acceptance Criteria:**

* The learner can export a selected deck.
* The exported file contains the deck's questions and answers.
* The exported file can be opened as a standard CSV file.

---

### User Story 2: Quiz Mode

**As a learner, I want an optional quiz mode so that I can practice answering cards without immediately seeing the answer.**

**Acceptance Criteria:**

* The learner can start a quiz from a selected deck.
* The learner can answer each question before revealing the correct answer.
* The learner can mark an answer as correct or incorrect.
* The quiz displays a final score.
* Quiz results do not change SM-2 scheduling unless explicitly configured to do so.

---

### User Story 3: Handle Invalid Input

**As a learner, I want invalid input to produce a helpful message so that I can correct it without losing my existing study material.**

**Acceptance Criteria:**

* Blank deck names are rejected.
* Blank card questions are rejected.
* Blank card answers are rejected.
* Invalid review choices are handled with an appropriate validation message.
* Invalid CSV records are handled gracefully.
* Normal invalid input does not crash the application.