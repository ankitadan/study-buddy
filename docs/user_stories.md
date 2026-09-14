# StudyBuddy User Stories

StudyBuddy is a Rails flashcard app that uses the SM-2 spaced-repetition algorithm to schedule reviews.

## Essential stories

### US-1: Manage decks

As a learner, I want to create, edit, and delete decks so that I can organize cards by subject.

**Acceptance criteria**

- A learner can create a deck with a name.
- A deck name cannot be blank or duplicated.
- A learner can edit a deck name and delete a deck.
- Deleting a deck also deletes its cards.

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
