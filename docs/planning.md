# StudyBuddy Planning

## Project goal

We will build StudyBuddy, a Rails flashcard application that helps learners review material using the SM-2 spaced-repetition algorithm. Users can organize cards into decks, study cards due for review, self-grade their recall, and view basic progress.

## Scope

### Essential

- Deck CRUD
- Card CRUD within a deck
- Question and answer validation
- Study session for due cards
- Again, Hard, Good, and Easy self-grading
- SM-2 scheduling with ease factor, interval, repetition count, and due date
- Basic progress statistics
- Automated unit and acceptance tests

### Optional

- CSV import/export
- Quiz mode and combo scoring
- Expanded analytics

Optional features will only be started after the essential workflow is tested and working.

## Collaboration

Tanvi Patel and Ankita Dan will use feature branches and small pull requests. We will pair program on the scheduler, database associations, and acceptance tests. For solo work, the other team member will review the pull request and test the feature locally. Driver and navigator roles will switch during pairing sessions, and each session will be recorded in `docs/pairing_log.md`.

## Definition of done

A feature is done when its acceptance criteria pass, invalid input is handled, automated tests pass, the code is reviewed, and relevant documentation is updated.

The project is done when a grader can install the app, create a deck, add cards, complete a due-card review, observe SM-2 scheduling, and run the documented test and coverage commands.

## Important correction from the proposal

The initial proposal referred to a Leitner system and numbered boxes. The implementation decision is now SM-2. We will use quality ratings, ease factor, intervals, repetitions, and next review dates. No box-based terminology will be used in the implementation or documentation.
