# Pairing Log

This document records the planning and pair-programming activities completed by Tanvi Patel and Ankita Dan during the development of StudyBuddy.

## Session 1 — 2026-08-30

**Participants:** Tanvi Patel and Ankita Dan

### Work Completed

* Discussed the idea for the StudyBuddy application.
* Discussed the purpose of the application and the intended learner workflow.
* Identified the major features that should be included in the project.
* Discussed which features should be essential and which could be optional.
* Discussed how the work could be divided between the two team members.

### Notes and Decisions

* Decided to build StudyBuddy as a Ruby on Rails flashcard application.
* Identified Deck Management and Card Management as core functionality.
* Discussed study sessions, self-grading, spaced repetition, and progress tracking as planned functionality.
* Agreed to prioritize the essential workflow before optional features.
* Agreed to use feature branches and review each other's work.

### Collaboration

This was a joint planning discussion. Both team members contributed ideas and discussed the project direction and feature scope together.

---

## Session 2 — 2026-09-03

**Participants:** Tanvi Patel and Ankita Dan

### Work Completed

* Reviewed the project scope and feature decisions from the initial planning discussion.
* Finalized the project proposal together.
* Reviewed the essential and optional features before submitting the proposal.
* Discussed the development priorities for the first stage of implementation.

### Notes and Decisions

* Confirmed the StudyBuddy application and planned feature set.
* Agreed to prioritize Deck Management and Card Management as the initial core functionality.
* Set a target of completing the Deck Management and Card Management functionality by September 13.
* The project proposal was submitted on September 2.

### Collaboration

Both team members participated in reviewing the proposal and discussing the final project scope before submission.

---

## Session 3 — Rails Setup and Deck Management (2026-09-11)

**Driver:** Ankita Dan
**Navigator:** Tanvi Patel

### Work Completed

* Worked together on setting up the Rails application and development environment.
* Reviewed the Deck Management implementation.
* Discussed the Deck model and its relationship with cards.
* Reviewed the routes and overall application structure.
* Tested the main Deck CRUD workflow.

### Notes and Decisions

* Confirmed that a deck should have many cards.
* Discussed how cards should remain associated with their parent deck.
* Decided to use nested routes for Card Management within a deck.
* Discussed deleting associated cards when a deck is deleted.

### Role Switch

The Driver and Navigator roles were switched during the development process so that both team members could participate in implementation and review.

---

## Session 4 — Card Management and Integration (2026-09-12)

**Driver:** Tanvi Patel
**Navigator:** Ankita Dan

### Work Completed

* Reviewed Tanvi's implementation of Card Management.
* Worked together to integrate Card Management with the Deck Management workflow.
* Reviewed Card creation, viewing, editing, and deletion within a deck.
* Tested that cards were associated with the correct deck.
* Reviewed validation for card questions and answers.
* Reviewed the flashcard navigation workflow on the deck detail page.

### Notes and Decisions

* Confirmed that Card Management should use nested routes under a deck.
* Confirmed that each card belongs to its associated deck.
* Reviewed the behavior for creating cards from the deck detail page.
* Discussed displaying cards one at a time and allowing the learner to move between cards.
* Reviewed the Next Card and Previous Card workflow while keeping the learner within the selected deck.
* Confirmed that blank questions and answers should not be accepted.

### Role Switch

Roles were switched during the session so that both partners could participate in implementation, testing, and review.

---

## Session 5 — Testing, Validation, and Debugging (2026-09-14)

**Driver:** Ankita Dan
**Navigator:** Tanvi Patel

### Work Completed

* Tested the Deck and Card Management features together.
* Reviewed the interaction between the deck detail page and Card Management.
* Tested validation for invalid deck and card information.
* Reviewed RSpec tests for Deck Management.
* Identified and fixed issues caused by differences between earlier assumptions and the current nested routing and model structure.
* Reviewed the application after integrating the Deck and Card functionality.

### Notes and Decisions

* Confirmed that Deck validation should prevent a deck from being saved without a name.
* Confirmed that Card validation should require both a question and an answer.
* Reviewed the expected behavior for invalid input.
* Discussed keeping the automated tests consistent with the current application routes and models.
* Verified that deleting a deck also deletes its associated cards.

### Role Switch

The Driver and Navigator roles were switched during the session to allow both partners to participate in testing and debugging.

---

## Session 6 — Project Review and Documentation (2026-09-14)

**Driver:** Tanvi Patel
**Navigator:** Ankita Dan

### Work Completed

* Reviewed the completed Deck and Card Management functionality against the planned scope.
* Reviewed user stories and acceptance criteria.
* Reviewed automated tests and project documentation.
* Discussed the remaining StudyBuddy features that would be implemented after the core Deck and Card workflow.
* Reviewed the project against the September 13 milestone.

### Notes and Decisions

* Confirmed that Deck Management and Card Management were the first major milestone.
* Reviewed Tanvi's Card Management and flashcard navigation work together with the Deck Management workflow.
* Agreed that future study-session and SM-2 functionality should build on the completed deck/card foundation.
* Discussed distinguishing implemented functionality from planned features in the documentation.

### Role Switch

The Driver and Navigator roles were switched during the review so that both partners could review the implementation and documentation.

---

### Session 7 — Spaced Repetition SM-2

**Driver:** Ankita Dan
**Navigator:** Tanvi Patel

**Work completed:**

* Ankita implemented the spaced-repetition/SM-2 functionality.
* Added review-related fields such as repetition count, interval, ease factor, and next review date.
* Implemented the different review ratings: Again, Hard, Good, and Easy.
* Implemented scheduling logic for future reviews.
* Added handling for overdue and due cards.
* Added tests covering the SM-2 calculations and edge cases.

**Testing included:**

* Initial review behavior.
* Again/reset behavior.
* Increasing intervals after successful reviews.
* Hard and Easy rating behavior.
* Ease-factor changes and minimum ease factor.
* Due and overdue cards.
* Future cards being excluded.
* Reviewed cards being removed from the due queue.

**Collaboration:** Tanvi reviewed how the spaced-repetition functionality would interact with study sessions and the existing Card model.

---

### Session 8 — Study Session and Review Flow

**Driver:** Tanvi Patel
**Navigator:** Ankita Dan

**Work completed:**

* Tanvi primarily implemented the study-session behavior and review flow.
* Implemented the one-card-at-a-time study experience.
* Ensured the question appears before the answer.
* Added answer reveal behavior.
* Added rating actions after the answer is revealed.
* Connected the review flow with the spaced-repetition functionality.
* Added tests for the study-session behavior.

**Testing included:**

* Starting a study session.
* Showing only due cards.
* Excluding future cards.
* Keeping cards scoped to the selected Deck.
* Revealing answers.
* Processing Again, Hard, Good, and Easy ratings.
* Rejecting invalid ratings.
* Handling empty study sessions.
* Removing a graded card from the current queue.
* Handling the final card in a session.

**Collaboration:** Ankita worked with Tanvi to integrate the study-session flow with the SM-2 scheduling logic.

---

### Session 9 — Deck Progress, Mastery, Streaks, and Weekly Activity

**Driver:** Tanvi Patel
**Navigator:** Ankita Dan

**Work completed:**

* Tanvi primarily implemented Deck progress tracking.
* Added mastery stages for cards.
* Added current and longest study streaks.
* Added streak milestones and goals.
* Added weekly activity tracking.
* Added mastery progress and remaining-card information.
* Added tests for progress calculations and edge cases.

**Testing included:**

* Empty Deck progress.
* New, Learning, and Mastered cards.
* Mastery percentage.
* Cards remaining to reach mastery.
* Current streaks.
* Longest streaks.
* Missed study days.
* At-risk streaks.
* Streak milestones.
* Weekly Monday–Sunday activity.
* Future dates.
* Activity from other Decks being excluded.

**Collaboration:** Both members reviewed how progress information should reflect the review data generated by study sessions.

---

### Session 10 — CSV Import and Export

**Driver:** Ankita Dan
**Navigator:** Tanvi Patel

**Work completed:**

* Ankita primarily implemented CSV import and export.
* Added CSV export for cards belonging to the selected Deck.
* Added CSV import for adding Cards to a selected Deck.
* Added validation for imported records.
* Implemented partial imports so valid records are imported while invalid records are skipped.
* Added user feedback showing the number of imported and skipped records.
* Added tests covering normal and edge-case CSV data.

**Testing included:**

* Importing multiple valid records.
* Importing into the selected Deck.
* Missing files.
* Missing required headers.
* Partially valid CSV files.
* Blank questions or answers.
* Commas inside fields.
* Quotes inside fields.
* Newlines inside fields.
* Exporting multiple Cards.
* Exporting an empty Deck.
* Ensuring Cards from other Decks are not exported.

**Collaboration:** Tanvi reviewed the integration with Card Management and Deck selection.

---

### Session 11 — Integration, Testing, and Debugging

**Participants:** Tanvi Patel, Ankita Dan
**Primary focus:** Feature integration

**Work completed:**

* Integrated the independently developed feature areas.
* Tested interactions between Cards, reviews, study sessions, SM-2 scheduling, and progress tracking.
* Tested CSV functionality with the existing Card and Deck structure.
* Investigated and fixed integration issues.
* Reviewed edge cases across multiple features.

**Collaboration:**

* Both members worked together on debugging and integration.
* Reviewed test failures and traced issues across models, requests, services, and views.
* Confirmed that individual feature implementations worked correctly together.

---

### Session 12 — Final Testing and Project Review

**Participants:** Tanvi Patel, Ankita Dan
**Primary focus:** Final validation and documentation

**Work completed:**

* Ran the complete RSpec test suite.
* Reviewed feature behavior against the project requirements.
* Tested important edge cases.
* Reviewed UI behavior and user feedback.
* Reviewed documentation and presentation material.
* Confirmed that the final features were integrated into the application.

**Final testing result:**

* 198 RSpec examples
* 0 failures
* 99.35% line coverage
* 96.92% branch coverage

**Collaboration:** Both members participated in final testing, debugging, review, and documentation.

---

## Feature Ownership Summary

| Feature | Primary Owner | Testing |
|---|---|---|
| Rails Setup | Ankita | Both |
| Deck Management | Ankita | Both |
| Card Management | Tanvi | Both |
| Spaced Repetition / SM-2 | Ankita | Both |
| CSV Import/Export | Ankita | Both |
| Study Session Behavior | Tanvi | Both |
| Deck Progress, Mastery, Streaks & Weekly Activity | Tanvi | Both |
| Feature Integration | Both | Both |
| End-to-End Testing | Both | Both |
| Debugging | Both | Both |
| Final Review & Documentation | Both | Both |

## Collaboration Practices

Tanvi and Ankita divided feature ownership while collaborating on integration, debugging, and testing. Ankita primarily worked on Rails setup, Deck Management, spaced repetition/SM-2, and CSV import/export, including the associated test cases. Tanvi primarily worked on Card Management, study-session behavior and review flow, and Deck progress features including mastery, streaks, and weekly activity, including the associated test cases.

Both members worked together when integrating these components, resolving issues between features, performing end-to-end testing, and reviewing the final application. Feature branches were used to keep development organized before integration, and both members participated in project planning, review, debugging, and final documentation.
