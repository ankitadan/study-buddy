# StudyBuddy Design

## Architecture

StudyBuddy is a Rails application with a thin web/UI layer and domain behavior kept in models and service objects.

| Component | Responsibility |
|---|---|
| `Deck` model | Stores a deck name and owns its cards. |
| `Card` model | Stores question, answer, scheduling metadata, and review history. |
| `Scheduler` service | Applies SM-2 to a card and a review quality. |
| `Review` model | Records a card review, quality, and timestamp. |
| `StatsTracker` or dashboard query | Calculates due cards, reviewed cards, mastery, and streaks. |
| Controllers | Validate requests and coordinate models/services. |
| Views | Render deck management, card forms, study sessions, and progress. |
| Database | Persists decks, cards, reviews, and scheduling state. |

The main flow is:

1. A learner selects a deck.
2. The app finds cards with `next_review_date <= today`.
3. The learner views the question, reveals the answer, and selects a rating.
4. `Scheduler` maps the rating to an SM-2 quality score and updates the card.
5. The app records the review and shows the next due date.

## Card scheduling data

Each card should store at least:

- `question`
- `answer`
- `repetition` or completed-review count
- `interval` in days
- `ease_factor`, initially 2.5
- `next_review_date`
- `deck_id`

## SM-2 decision

StudyBuddy will use SM-2 rather than a Leitner box system. The interface uses learner-friendly ratings mapped to quality scores:

| Rating | Quality | Intended meaning |
|---|---:|---|
| Again | 0 | Complete failure or did not remember |
| Hard | 3 | Remembered with significant difficulty |
| Good | 4 | Correct with normal effort |
| Easy | 5 | Correct immediately and confidently |

For quality below 3, the repetition sequence resets and the card is scheduled for a short retry. For successful reviews, the first two intervals are 1 and 6 days; later intervals use the previous interval and ease factor. The ease-factor update follows SM-2 and is clamped to a minimum of 1.3.

The project should not describe cards as moving between numbered boxes. It should describe intervals, ease factor, repetitions, and due dates.

## UI workflows

### Deck and card workflow

`Decks index -> New deck -> Deck detail -> Add card -> Edit/Delete card`

### Study workflow

`Dashboard or Deck detail -> Start review -> Show question -> Reveal answer -> Choose rating -> Next due date -> Next card`

### Empty and invalid states

- No decks: show a prompt to create the first deck.
- No cards in a deck: show an Add Card action.
- No cards due: show “Nothing to review today.”
- Invalid form: preserve entered values and display field-level errors.

## Design tradeoffs

- SM-2 provides adaptive intervals and matches the project goal of spaced repetition, but requires more state than a simple box number.
- Storing scheduling fields on `Card` makes due-card queries simple; storing `Review` records preserves history for statistics.
- CSV import/export and quiz mode are optional so the core CRUD and scheduling workflow remains achievable.
