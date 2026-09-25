# Testing

StudyBuddy currently uses RSpec for its executable automated test suite. The tests are isolated with transactional fixtures and use the test database.

## Running tests

```bash
bundle exec rspec
```

RSpec starts SimpleCov through `spec/rails_helper.rb`. To run the suite and refresh the coverage report explicitly:

```bash
COVERAGE=true bundle exec rspec
```

The HTML report is generated at `coverage/index.html`. Running `bin/rails test` currently reports zero tests because the legacy Minitest controller and model files contain only commented examples; the two system-test examples are not part of that command's executable suite.

## Executed test cases with coverage
![alt text](image.png)
### Models: 42 examples

- `Card` accepts valid question, answer, and deck attributes.
- `Card` validates the presence of its question, answer, and deck.
- `Card` belongs to a deck.
- Cards can be edited and deleted.
- Deleting a card's deck removes the card.
- `Deck` accepts and persists a name and description.
- `Deck` has many cards and destroys associated cards when deleted.
- `Card#review` applies SM-2 for Again, Hard, Good, and Easy, and the ease factor never falls below 1.3.
- `Card#schedule` applies the same SM-2 update as `Card#review` without saving.
- `Card.due` returns cards due today or earlier, most overdue first, and excludes reviewed and future cards.
- `Review` requires a valid rating quality and review date, and is deleted with its card.
- Deck progress returns zeros for empty decks, counts due cards and reviews per deck, and calculates the study streak (consecutive days, same-day reviews counted once, yesterday keeps the streak, a missed day ends it).

### Requests: 102 examples

- Deck index, new, show, edit, update, create, and delete actions return the expected responses, render the expected content, and redirect correctly.
- Deck creation and update reject invalid names without changing persisted data.
- Deck deletion removes associated cards.
- Card index, new, show, edit, create, update, and delete actions work through nested deck routes.
- Cards are scoped to their selected deck, including empty-deck and cross-deck cases.
- Blank card questions and answers are rejected without creating or updating a card.
- Deck study navigation selects the first card by default, honors a selected card, and shows the correct previous/next controls.
- Invalid card IDs fall back to the first card, and empty decks show an empty-state message.
- Study sessions show only the selected deck's due cards (today or earlier), hide the answer until it is revealed, and show the number of cards due.
- Again, Hard, Good, and Easy ratings update the card through SM-2, remove it from the queue, and show the next due card or a "no cards due" message.
- Study sessions reject invalid ratings, cards that are not due, and cards from another deck without changing them.
- Grading a card records a review; rejected grades do not.
- The decks page shows due cards, total reviews, and study streak for each deck, zeros for new decks, and an empty-state message when there are no decks.
- The deck progress page shows stat tiles, active and at-risk streak messages, the streak goal bar with only earned badges, the New → Learning → Mastered bar with pending cards, reviews, and days, and the Monday-to-Sunday week strip, with empty states for new decks.
- Finishing a study session shows a one-time summary of only that session's reviews (count, remembered percentage, streak, rating breakdown, next due date); unfinished sessions from earlier days are discarded.

### Services: 26 examples

- `DeckProgress` returns zeros for an empty deck, groups cards into new, learning, and mastered by SM-2 interval, and reports active, at-risk, and no streak.
- `DeckProgress` finds the longest streak, earns badges from it (kept after a streak ends), and reports the next milestone and how full the streak goal bar is.
- `DeckProgress` mastery progress puts new cards at 0%, cards rated Again at 25%, and mastered cards at 100%, moves cards forward with each Good review, estimates reviews and days left to mastery, and does not save the simulated reviews.
- `DeckProgress#this_week` returns Monday to Sunday with today, future days, and per-day review counts for the deck only.
- `StudySessionSummary` counts only the session's reviews, splits them by rating, calculates the remembered percentage, and reports the next review date.

### Routing: 7 examples

- Deck routes map GET index/new/show/edit, POST create, PATCH update, and DELETE destroy to the expected controller actions.

### Views: 12 examples

- Card index displays question and answer and links to the card show and new-card form.
- Card new and edit views render the form with the correct nested action and navigation link.
- Card show displays question and answer, edit and delete actions, and a link back to the card list.

## Latest test run

Command: `bundle exec rspec`

- 189 examples, 0 failures
- Line coverage: 298/300 (99.33%)
- Branch coverage: 61/63 (96.82%)
- Coverage report: `coverage/index.html`

The 80% coverage target is met. The run emits deprecation warnings for `SimpleCov.add_filter` and Rack's `:unprocessable_entity` status alias; these warnings do not affect the passing result.


