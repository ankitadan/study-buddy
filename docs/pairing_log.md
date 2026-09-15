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

## Collaboration Practices

Tanvi Patel and Ankita Dan used a combination of individual feature development and pair programming. Tanvi primarily worked on Card Management and flashcard navigation, while Ankita primarily worked on Rails setup and Deck Management. Pair-programming sessions were used to integrate the two areas, test the application, debug issues, and make design and implementation decisions together.

During paired work, Driver and Navigator roles were used and switched regularly. Both partners participated in reviewing the code and testing the functionality so that they understood how the Deck and Card components worked together.

The team also used feature branches and pull requests to support code review and testing between team members.
