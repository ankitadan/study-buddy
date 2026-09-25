# StudyBuddy Retrospective

## What went well

- The team successfully implemented the core StudyBuddy functionality for managing decks and flashcards. Users can create, view, edit, and delete decks, while also adding, editing, viewing, and deleting cards within a selected deck.

- A major success was organizing cards through nested deck routes. This ensured that each card remained associated with the correct deck and prevented cards from other decks from appearing during navigation. The team also implemented validations requiring deck names, card questions, and card answers. Invalid submissions are rejected without overwriting existing information.

- The card navigation feature also worked well. Users can view one card at a time and move forward or backward through cards in a consistent order. The interface correctly handles the first card, last card, and empty decks. Deleting a deck also removes its associated cards, preventing orphaned records.

- The team also improved the project through routing fixes, view updates, system tests, request tests, model tests, CI fixes, and RuboCop corrections. These improvements helped make the application more reliable and maintainable.

## What was difficult

- One difficult part was establishing relationship between the deck and card features along with nested routes, nested controllers, views, and database to work together correctly.

- The team also encountered integration issues involving routes, views, CI checks, and RuboCop. Resolving these issues required repeated testing and coordination between team members working on different branches.

- Merging the SM-2 work caused a confusing database problem. Before the final SM-2 migration was merged, one of us had tried out the SM-2 fields locally with our own migrations that were never committed. When we pulled the merged version, running `db:migrate` failed with "duplicate column name: repetition." The local database already had the columns, but Rails had no record of the new migration being run, so it tried to add them a second time. The old local column also had slightly different settings from the committed schema. Nothing was wrong with the code itself. The problem was only on one laptop, which made it hard to spot at first. We fixed it by marking the migration as already applied and adjusting the column to match `db/schema.rb`. The same pull also added a new gem, so `bundle install` had to be run before any tests would start.

## What we would improve next time

- Next time, the team would define the route structure and feature responsibilities earlier. Establishing clear conventions for nested routes, controller actions, view partials, and naming would reduce integration conflicts.

- We would also create tests before implementing each major feature. Writing acceptance tests for navigation, deletion, validation, and empty-state behavior at the beginning would make it easier to identify missing requirements early.

- The team could improve communication by using smaller, focused branches and merging changes more frequently. Regular integration checks would help catch conflicts before multiple features are completed.

- We would only commit migrations that are meant to be shared, and throw away experimental local migrations (or reset the local database) before pulling a teammate's version of the same change. After every pull, we would run `bundle install`, `bin/rails db:migrate`, and the test suite before starting new work, so setup problems show up right away instead of in the middle of a feature.

- We would also plan the SM-2 spaced-repetition functionality earlier. Although the deck and card management features provide the foundation for the application, defining how review dates, easiness factors, intervals, and repetition counts would be stored could make the next stage of development more organized.

## Did the final app meet the original goal?

Yes, the final application met the original goal of providing students with an organized flashcard system. Users can create decks, manage study cards, and review cards one at a time within the correct deck.

The application also satisfies the essential user stories for deck management and card management. It includes validation, navigation, deletion behavior, error handling, and empty-state messages. The implementation provides a strong foundation for adding and fully integrating the SM-2 spaced-repetition review system in future development.

## Action items

- Improve the user interface with clearer styling and feedback messages.
- Improve test coverage for edge cases involving card deletion and navigation.
- After pulling, run `bundle install`, `bin/rails db:migrate`, and `bundle exec rspec` before starting new work.
- Keep experimental migrations out of shared branches, and reset the local database when switching to a teammate's version of a migration.
