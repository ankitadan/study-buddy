# StudyBuddy Backlog

Update this file as work progresses. Items are grouped by priority and status.

## Done

* ✅ Set up the Rails application and development environment
* ✅ Configure the database and initial project structure
* ✅ Configure RSpec
* ✅ Create Deck model and migration
* ✅ Add Deck validation
* ✅ Implement Deck CRUD
* ✅ Create Card model and Deck-Card association
* ✅ Implement Card CRUD within a deck
* ✅ Add blank-field validation for cards
* ✅ Add flashcard navigation within a deck
* ✅ Implement the Scheduler service using SM-2
* ✅ Add study-session flow for due cards
* ✅ Add due-card query for today and overdue cards
* ✅ Add acceptance tests for the study-session workflow
* ✅ Add review history
* ✅ Add basic per-deck progress statistics and study streak calculation on the decks page
* ✅ Add per-deck progress page with streak status, streak badges, mastery bar, and this-week strip
* ✅ Add session-complete summary to study sessions
* ✅ Add `study:reset`, `study:reset_due`, and `study:backfill_streak` tasks for manual testing
* ✅ Add scheduler unit tests for Again, Hard, Good, and Easy
* ✅ Add Deck model RSpec tests
* ✅ Add Deck request/acceptance tests
* ✅ Document user stories and acceptance criteria
* ✅ Update project design documentation
* ✅ Review and refine the Deck and Card functionality
* ✅ Review automated tests and add missing test cases
* ✅ Review project documentation against the implemented functionality

## To Do: Essential

* ⬜ Run RuboCop and address relevant style offenses

## To Do: Stretch Features

* ⬜ Add CSV import/export
* ⬜ Add quiz mode and combo scoring
* ⬜ Add expanded analytics

## Definition of Done

An individual backlog item is considered done when:

* The required functionality has been implemented.
* The acceptance criteria are satisfied.
* Relevant valid and invalid cases have been tested.
* Automated tests pass for the implemented behavior.
* The code has been reviewed by the other team member when applicable.
* RuboCop issues related to the changed code have been addressed.
* Relevant documentation is updated when the feature changes application behavior or setup.

A feature remains in progress until its implementation and testing are complete.

The overall project will be considered done when the essential StudyBuddy workflow is implemented, tested, documented, and can be run successfully by a grader.
