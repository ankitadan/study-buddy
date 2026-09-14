# StudyBuddy Backlog

Update this file as work progresses. Items are grouped by priority and linked to user stories.

## Done

- [x] Create Rails project and configure RSpec — US-1 to US-8
- [x] Create Deck model, migration, validation, and CRUD — US-1
- [x] Create Card model with `deck_id` association — US-2
- [x] Add card CRUD inside a deck — US-2
- [x] Add blank-field validation for cards — US-2, US-8

## In Progress

- [ ] Implement `Scheduler` service using SM-2 — US-4
- [ ] Add study-session flow for due cards — US-3, US-4
- [ ] Add scheduler unit tests for Again, Hard, Good, and Easy — US-4

## To Do: essential

- [ ] Add review history — US-4
- [ ] Add due-card query for today and overdue cards — US-3
- [ ] Add progress dashboard and streak calculation — US-5
- [ ] Add request/system acceptance tests — US-1 to US-5
- [ ] Configure SimpleCov and document coverage — testing requirement
- [ ] Run RuboCop and fix style offenses — code quality requirement
- [ ] Update README and design documentation — documentation requirement

## To Do: optional/stretch

- [ ] Add CSV import/export — US-6
- [ ] Add quiz mode — US-7

## Definition of done for each item

- Code is implemented on a feature branch.
- Unit or acceptance tests cover the behavior, including relevant sad paths.
- Validation and error states are handled.
- RuboCop is clean for changed files.
- A focused commit and pull request describe the change.
- Documentation is updated when behavior or setup changes.
