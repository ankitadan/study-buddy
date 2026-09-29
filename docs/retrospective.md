# StudyBuddy Retrospective

## What went well

* Our team successfully implemented the main StudyBuddy features for managing decks and flashcards. Users can create, view, edit, and delete decks, and they can also add, view, edit, and delete cards within a selected deck.

* One thing that worked particularly well was using nested routes for cards. This helped us keep each card connected to the correct deck and prevented cards from different decks from being mixed together. We also added validations for deck names, card questions, and card answers so that invalid information cannot be submitted.

* The card navigation worked well after testing different cases. Users can move forward and backward through cards one at a time, and the application handles the first card, last card, and empty decks correctly. We also made sure that deleting a deck deletes its associated cards so that there are no orphaned records.

* We added CSV import functionality so users can add multiple cards at once. We also handled cases where a CSV contains both valid and invalid records. The valid records are imported, while invalid records are skipped and the user is informed about how many records were not imported.

* We also added the fields needed for the SM-2 spaced-repetition functionality, including repetition count, review interval, ease factor, and next review date. This allowed us to start incorporating spaced repetition into the application while keeping the existing card functionality intact.

* Testing and code quality were another area where we made good progress. We worked through system tests, request tests, model tests, CI issues, routing problems, and RuboCop corrections. Fixing these issues helped us catch problems that were not always obvious when testing the application manually.

## What was difficult

* One of the more difficult parts was connecting the deck and card features together. We had to make sure the nested routes, controllers, views, validations, and database relationships all worked together correctly. A small change in one area could sometimes affect another part of the application.

* We also ran into integration issues with routes, views, CI, and RuboCop while working on different branches. Since multiple people were working on different features, we sometimes had to spend time figuring out whether an issue came from our own changes or from something that had been merged from another branch.

* CSV import required us to think about cases beyond a normal successful upload. We had to make sure that one invalid record did not prevent valid records from being imported and that the user received useful feedback about the records that were skipped.

* The SM-2 migration also caused a confusing database issue during integration. One of us had experimented with the SM-2 fields locally using migrations that were not committed. When the committed SM-2 migration was later pulled, `db:migrate` failed with a "duplicate column name: repetition" error. The columns already existed in the local database, but Rails did not know that the new migration had effectively already been applied. The local columns also had slightly different settings from the committed schema. After investigating the issue, we marked the migration as already applied and adjusted the local columns to match `db/schema.rb`. We also had to run `bundle install` because the pull introduced a new gem dependency.

## What we would improve next time

* We would define the route structure and responsibilities for each feature earlier. Having a clear plan for nested routes, controllers, views, and naming conventions from the beginning would make it easier for everyone to work independently.

* We would write tests earlier in the development process instead of adding some of them after the feature was already implemented. Starting with tests for navigation, deletion, validation, CSV import, and empty states would have helped us identify missing cases sooner.

* We would also communicate more frequently when making changes that affect shared parts of the application. Using smaller branches and merging changes more often would make integration easier and reduce the number of conflicts we have to solve at once.

* We learned that database migrations need extra care when working as a team. Going forward, we would avoid keeping experimental migrations locally when switching to a teammate's implementation of the same feature. After pulling changes, we would also run `bundle install`, `bin/rails db:migrate`, and the test suite before continuing with new development.

* We would plan the SM-2 functionality earlier and decide on the expected behavior for review dates, intervals, ease factors, and repetition counts before implementing it. This would make it easier to connect the spaced-repetition logic to the study session instead of adding pieces of the functionality separately.

## Did the final app meet the original goal?

Yes. Our final application meets the main goal of providing students with an organized flashcard system.

Users can create and manage decks, manage cards within those decks, import multiple cards using CSV, and navigate through cards one at a time. The application also includes validation, empty-state handling, appropriate deletion behavior, and testing for important parts of the system.

We also added the data needed for the SM-2 spaced-repetition functionality, which gives us the ability to track information such as repetition count, review interval, ease factor, and next review date.

Overall, the project met the main requirements we set out to implement while also giving us experience with Rails, database relationships, testing, Git collaboration, migrations, and integrating multiple features developed by different team members.

## Action Items

* Continue improving the UI and make feedback messages clearer for users.
* Add more tests for edge cases involving card deletion, navigation, validation, and CSV imports.
* Continue testing and integrating the SM-2 review workflow with study sessions.
* Run `bundle install`, `bin/rails db:migrate`, and `bundle exec rspec` after pulling major changes.
* Avoid committing experimental migrations and make sure local database changes are synchronized before integrating a teammate's migration.
* Continue using smaller, focused branches and regular integration checks to reduce merge and setup issues.