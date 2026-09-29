# StudyBuddy User Stories

StudyBuddy is a Rails flashcard app that uses the SM-2 spaced-repetition algorithm to schedule reviews.

Each story's acceptance criteria include the happy path and the sad paths (invalid input, empty states, and missing records). Every criterion is covered by the RSpec suite; the [Testing](#testing) section maps stories to spec files.

## Essential stories

## Deck and Card Management

### US-1: Create a Deck

**As a student, I want to create a study deck with a name and description so that I can organize my study material by topic.**

**Acceptance Criteria:**

* The user can open the "Create a New Deck" page from the navigation.
* The user can enter a deck name and description.
* Submitting the form creates and saves the deck, and the user is redirected to it.
* A deck must have a name. A blank name is rejected and no deck is saved.
* Deck names must be unique. A name another deck already uses is rejected with the message "is already used by another deck", and no deck is saved.
* The same message is shown if the database rejects a duplicate name that slipped past the form check.

---

### US-2: View and Edit My Decks

**As a student, I want to see all of my decks with their progress and keep their details up to date so that I can choose which deck to study and keep my material organized.**

**Acceptance Criteria:**

* The My Decks page loads successfully and lists every deck.
* Each deck shows its cards due today, total reviews, and current study streak. A new deck shows zeros.
* Each deck links to its study session, its detail page, its progress page, and its CSV export.
* If there are no decks, an informative message asks the user to create one.
* The edit page shows the deck's current name and description.
* Saving valid changes updates the deck, and the user is redirected to it.
* A blank name is rejected, and the deck keeps its existing information.
* Renaming a deck to a name another deck already uses is rejected, and the deck keeps its existing name.

---

### US-3: View a Deck and Browse Its Cards

**As a student, I want to open a deck and move forward and backward through its cards so that I can read every card in the deck.**

**Acceptance Criteria:**

* The deck page shows the deck's name, description, and card management options.
* The first card is displayed by default, and only one card is displayed at a time.
* The displayed card shows its question and answer.
* Next Card and Previous Card move through the cards in a consistent order.
* The first card does not show Previous Card, and the last card does not show Next Card.
* An invalid card in the link falls back to the first card.
* Only cards from the selected deck are shown, and navigation stays within that deck.
* If the deck has no cards, an informative message and an "Add Your First Card" option are shown.

---

### US-4: Delete a Deck and Its Cards

**As a student, I want to delete a deck I no longer need, along with its cards, so that my study material stays organized and no orphaned cards remain.**

**Acceptance Criteria:**

* The user can delete a deck from the My Decks page or the deck page.
* The user is asked to confirm before the deck is deleted. The deck name is shown safely in the confirmation, even if it contains special characters.
* Deleting the deck also deletes all of its cards and their review history.
* Cards in other decks are not affected.
* The user is redirected to My Decks after deletion.

---

### US-5: Add a Card to a Deck

**As a student, I want to add cards with a question and answer to a deck, including while I am viewing it, so that I can build my study material whenever I need to.**

**Acceptance Criteria:**

* The user can open the new card form from the deck page ("+ Add New Card" or "Add Your First Card") and from the deck's card list.
* The user can enter a question and answer.
* Submitting valid information creates the card in the selected deck.
* The question cannot be blank, and the answer cannot be blank. Invalid input does not create a card.
* A new card is due for study right away.
* The new card is available when browsing the deck.

---

### US-6: View All Cards in a Deck

**As a student, I want to see all of a deck's cards on one page so that I can review and manage the whole deck at a glance.**

**Acceptance Criteria:**

* The user can open the card list from the deck page with "All Cards".
* The page lists every card in the deck with its question and answer.
* Each card links to its own page and to its edit form.
* The page links to the new card form and back to the deck.
* Only cards from the selected deck are listed.
* If the deck has no cards, the page loads successfully and shows an informative message.

---

### US-7: View, Edit, and Delete a Card

**As a student, I want to view, edit, and delete a card so that I can correct my study material or remove cards I no longer need.**

**Acceptance Criteria:**

* A card's page shows its question, answer, and SM-2 scheduling details, with links to edit it, delete it, and return to the deck's cards.
* The edit form shows the card's current question and answer.
* Saving valid changes updates the card, and it stays in the same deck.
* Blank questions or answers are rejected, and the existing card information is not overwritten.
* The user can delete a card from the deck page or the card's page, and is asked to confirm first.
* Deleting a card removes it and its review history from the deck. The deck and other cards are not affected.
* The remaining cards keep their order. If no cards remain, the deck shows its empty-state message.

---

## Studying

### US-8: Study Due Cards

**As a student, I want to study only the cards that are due so that my session focuses on the material I need to review now.**

**Acceptance Criteria:**

* A study session shows only the selected deck's cards that are due today or earlier, or have never been reviewed.
* The most overdue cards are shown first.
* Cards scheduled for the future and cards from other decks are not shown.
* The page shows how many cards are due.
* The question is shown first. The answer is hidden until the user chooses "Show Answer", which also shows the rating buttons.
* After a card is graded, it leaves the queue and the next due card is shown.
* After the last due card is graded, the message "No cards are due for review. Great job!" is shown.
* A deck with no cards shows an informative message. A deck that does not exist returns "not found".

---

### US-9: Schedule Reviews with SM-2

**As a student, I want my self-assessment to schedule each card's next review so that difficult cards come back sooner and well-known cards come back later.**

**Acceptance Criteria:**

* The user can rate a card Again, Hard, Good, or Easy. These map to SM-2 quality scores 0, 3, 4, and 5.
* Each rating updates the card's repetition count, interval, ease factor, and next review date.
* Again resets the repetition sequence and schedules the card for tomorrow.
* The first successful review schedules the card 1 day later, and the second 6 days later.
* Good keeps the ease factor unchanged, Hard lowers it, and Easy raises it.
* The ease factor never falls below 1.3.
* The user is told when the graded card is due next.
* Each grade records a review, which progress and streaks are calculated from.
* An invalid rating, a card that is not due yet, and a card from another deck are rejected. The card is not changed and no review is recorded.

---

### US-10: See a Session Summary

**As a student, I want a summary when I finish my due cards so that I can see how the session went.**

**Acceptance Criteria:**

* After the last due card is graded, a "Session complete" summary is shown.
* The summary shows the number of cards reviewed, the percentage remembered, the study streak, a breakdown by rating, and the next review date in the deck.
* Only reviews from this session are counted. Earlier sessions and other decks are ignored.
* The summary is shown only once.
* No summary is shown if nothing was graded.
* An unfinished session from an earlier day is discarded.

---

## Progress

### US-11: Keep a Study Streak

**As a student, I want to see my study streak for each deck so that I stay motivated to study every day.**

**Acceptance Criteria:**

* The streak counts consecutive days with at least one review in the deck. Several reviews on the same day count once.
* Studying today gives a one-day streak.
* If the user studied yesterday but not yet today, the streak is kept and marked at risk, with a "Study now" link.
* The streak resets to zero after a full missed day.
* Reviews from other decks do not count toward the deck's streak.
* The longest streak is tracked separately from the current streak.
* Badges are earned at the 3, 7, 14, and 30-day milestones and are kept after a streak ends.
* A streak goal bar fills toward the next milestone and is full once every milestone is passed.

---

### US-12: View Deck Progress and Mastery

**As a student, I want a progress page for each deck so that I can see how close I am to mastering it.**

**Acceptance Criteria:**

* The progress page is linked from My Decks and the deck page. A deck that does not exist returns "not found".
* The page shows cards due today, total reviews, current streak, longest streak, and the streak goal.
* A mastery bar groups the cards into New, Learning, and Mastered. A card is mastered once its review interval reaches 21 days, and a card rated Again moves back to the start of Learning.
* The mastery percentage averages the deck's cards: a new card counts as 0% and a mastered card as 100%.
* The page estimates the cards, reviews, and days left to master the deck, assuming every future rating is Good. Days left are based on the slowest card.
* Calculating the estimate does not change any cards.
* When every card is mastered, the page celebrates it.
* A "This week" strip shows Monday to Sunday, marks today, and shows a review count for each day the deck was studied.
* A new deck shows zeros and empty states instead of an error.

---

## Optional stories

### US-13: Export a Deck as CSV

**As a student, I want to export a deck as a CSV file so that I can back it up or share it.**

**Acceptance Criteria:**

* Each deck on My Decks has an export link that downloads that deck's CSV file.
* The file has the columns `deck_name`, `description`, `question`, and `answer`, with one row per card.
* A deck with no cards still exports its header and deck information.
* Cards from other decks are not exported.
* Questions and answers containing commas, quotes, or line breaks are exported correctly.

---

### US-14: Import Cards from CSV

**As a student, I want to import cards from a CSV file into a deck so that I can reuse study material without typing every card.**

**Acceptance Criteria:**

* The "Import Cards (CSV)" option is on the deck page and adds cards to that deck.
* The file must have `question` and `answer` columns. Other columns are ignored.
* Importing without choosing a file, or with a file missing the required columns, shows an error on the deck page and imports nothing.
* Valid rows are imported and invalid rows, such as a blank answer, are skipped. The message reports how many cards were imported and how many rows were skipped.
* Questions and answers containing commas, quotes, or line breaks are imported correctly.

## Story Classification

| Story | Feature | Classification |
| ----- | ------- | -------------- |
| US-1 | Create a Deck | Essential |
| US-2 | View and Edit My Decks | Essential |
| US-3 | View a Deck and Browse Its Cards | Essential |
| US-4 | Delete a Deck and Its Cards | Essential |
| US-5 | Add a Card to a Deck | Essential |
| US-6 | View All Cards in a Deck | Essential |
| US-7 | View, Edit, and Delete a Card | Essential |
| US-8 | Study Due Cards | Essential |
| US-9 | Schedule Reviews with SM-2 | Essential |
| US-10 | See a Session Summary | Essential |
| US-11 | Keep a Study Streak | Essential |
| US-12 | View Deck Progress and Mastery | Essential |
| US-13 | Export a Deck as CSV | Optional |
| US-14 | Import Cards from CSV | Optional |

## Testing

These user stories are supported by automated RSpec tests. Run them from the project root:

```bash
bundle exec rspec
```

| Stories | Spec files |
| ------- | ---------- |
| US-1 to US-4 | `spec/models/deck_spec.rb`, `spec/requests/decks_spec.rb`, `spec/routing/cards_routing_spec.rb` |
| US-5 to US-7 | `spec/models/card_spec.rb`, `spec/requests/cards_spec.rb`, `spec/views/cards/` |
| US-4, US-7 (confirmations) | `spec/requests/deck_import_export_ui_spec.rb` |
| US-8, US-9 | `spec/models/card_spec.rb`, `spec/models/review_spec.rb`, `spec/requests/study_sessions_spec.rb` |
| US-10 | `spec/requests/study_sessions_spec.rb`, `spec/services/study_session_summary_spec.rb` |
| US-11, US-12 | `spec/models/deck_spec.rb`, `spec/services/deck_progress_spec.rb`, `spec/requests/deck_progress_spec.rb` |
| US-13, US-14 | `spec/requests/cards_spec.rb`, `spec/requests/deck_import_export_ui_spec.rb` |

See [testing.md](testing.md) for the full list of test cases and the latest coverage report.
