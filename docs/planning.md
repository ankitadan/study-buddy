# StudyBuddy Planning

## Project goal

We will build StudyBuddy, a Rails flashcard application that helps learners review material using the SM-2 spaced-repetition algorithm. Users can organize cards into decks, study cards due for review, self-grade their recall, and view basic progress.

## Scope
During the planning discussion, we separated the features into essential and optional functionality so that the core application could be completed and tested before additional features were attempted.
### Essential

- Deck CRUD
- Card CRUD within a deck
- Question and answer validation
- Study session for due cards
- Again, Hard, Good, and Easy self-grading
- SM-2 scheduling with ease factor, interval, repetition count, and due date
- Basic progress statistics
- Automated unit and acceptance tests

### Stretch Features

- CSV import/export
- Quiz mode and combo scoring
- Expanded analytics

Optional features will only be started after the essential workflow is tested and working.

## Collaboration

We decided to use feature branches and small pull requests so that individual changes could be developed and reviewed separately. For individual work, one team member will implement a feature on a feature branch while the other team member reviews the pull request and tests the feature locally.

For more complex functionality, particularly the scheduler, database associations, and acceptance tests, we planned to use pair programming. During pairing sessions, the Driver and Navigator roles will switch so that both team members participate in implementation and review. Pairing sessions will be documented in`docs/pairing_log.md`.

## Definition of done

We agreed that an individual feature or user story is considered done when:

* Its acceptance criteria are satisfied.
* Valid and invalid inputs are handled appropriately.
* Automated tests for the feature pass.
* The code has been reviewed by the other team member when applicable.
* The feature works correctly when tested locally.
* Relevant project documentation has been updated.

The overall project will be considered done when a grader can install and run the application, create a deck, add cards, complete a due-card review, observe the SM-2 scheduling behavior, and run the documented test commands.

## Important correction from the proposal

The initial proposal referred to a Leitner system and numbered boxes. The implementation decision is now SM-2. We will use quality ratings, ease factor, intervals, repetitions, and next review dates. No box-based terminology will be used in the implementation or documentation.

## Prioritization

The team agreed to prioritize the core deck and card workflow before implementing optional features. This allows the application to have a complete and testable foundation before additional functionality such as CSV import/export, quiz mode, or expanded analytics is attempted.

The planned development order is:

1. Rails application setup
2. Deck Management
3. Card Management
4. Validation and automated testing
5. Study sessions
6. SM-2 scheduling
7. Basic progress statistics
8. Optional features, if time permits

