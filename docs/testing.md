# Testing Plan

StudyBuddy uses RSpec and Rails model/request/system tests. Tests should be fast, isolated, repeatable, and independent of execution order.

## Running tests

```bash
bundle exec rspec
```

To generate a coverage report:

```bash
COVERAGE=true bundle exec rspec
```

The report is generated in `coverage/index.html` when SimpleCov is configured in `spec/spec_helper.rb`.

## Unit tests

### Card and Deck

- A valid card can be created with a question, answer, and deck.
- A card is invalid when its question is blank.
- A card is invalid when its answer is blank.
- A card belongs to a deck.
- A deck has many cards.
- Duplicate deck names are rejected.
- Deleting a deck deletes its cards.

### Scheduler

- A new card starts with the configured default ease factor and no completed repetitions.
- A Good review updates the interval and next review date.
- An Again review resets the repetition sequence and schedules a short interval.
- Hard reduces the ease factor while Easy increases or preserves it according to the SM-2 rules.
- The ease factor cannot go below 1.3.
- Invalid quality values raise a clear validation error or `ArgumentError`.
- Date calculations use the supplied date, allowing deterministic tests.

### Progress tracking

- Due count includes cards due today and overdue cards.
- A missed day breaks the current streak.
- An empty account returns an empty summary rather than raising an error.

## Acceptance/system tests

- Create a deck, add a card, and see it listed on the deck page.
- Edit a card question and answer and verify the updated values.
- Delete a card and verify it no longer appears.
- Start a study session, reveal an answer, grade a card, and verify its next review date.
- Start a study session with no due cards and verify the empty-state message.
- Submit blank card fields and verify the form displays validation errors.

The target is at least 80% statement coverage, with special attention to scheduler branches and invalid-input paths.
