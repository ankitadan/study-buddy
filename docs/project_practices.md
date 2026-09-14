# Project Practices

## Code quality

- Use Rails conventions and single-responsibility classes.
- Keep SM-2 calculations in a `Scheduler` service rather than controllers or views.
- Use meaningful names such as `next_review_date`, `ease_factor`, and `quality`.
- Validate required fields and use database constraints where appropriate.
- Avoid duplicating scheduling logic in study-session code and tests.
- Run `bundle exec rubocop` before merging.

## Comments

Comments should explain why a decision exists, especially the rating-to-quality mapping, SM-2 minimum ease-factor rule, and any simplifying assumptions. Do not comment obvious code such as `@card.save`.

## Commit messages

Use imperative, focused messages:

```text
Add card CRUD inside deck details
Implement SM-2 interval scheduling
Validate blank card questions and answers
Add acceptance tests for due-card reviews
```

For non-obvious changes, include a short body explaining the reason and test command.

## Git workflow

- Keep `main` stable.
- Create focused branches such as `feature/card-crud` and `feature/sm2-scheduler`.
- Commit incremental changes instead of one final bulk commit.
- Open pull requests for non-trivial work.
- Review tests, validation, and documentation before merging.
- Ensure both team members contribute meaningful commits and reviews.

## Pair programming

Use driver and navigator roles, switch roles regularly, discuss design decisions, and record each real session in `docs/pairing_log.md`.

## Documentation

Keep `README.md`, `docs/design.md`, `docs/user_stories.md`, `docs/backlog.md`, and the testing instructions current. Any change to the SM-2 behavior must update the design document and relevant tests.
