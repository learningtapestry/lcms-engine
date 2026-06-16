---
name: migrate
description: Create a Rails migration for the lcms-engine gem using the rails-expert agent. Pass the migration description as arguments. Use for schema changes — adding/removing columns, indexes, foreign keys, JSONB metadata, etc.
---

Use the `rails-expert` agent to create a Rails migration for: $ARGUMENTS

Important: this is a **Rails Engine**. Migrations under `db/migrate/` ship to every host app via the `append_migrations` initializer in `lib/lcms/engine/engine.rb`. Treat every migration as production-bound. After authoring, hand the migration off to the `migration-reviewer` agent for safety review.

Compose service is `app`. Rails-level commands run inside the dummy host app at `spec/dummy/`.

Steps:
1. Understand the schema change needed.
2. Generate the migration inside the engine's `db/migrate/`:
   ```bash
   docker compose run --rm app sh -c 'cd spec/dummy && bundle exec rails generate migration <MigrationName>'
   ```
   Then move the generated file from `spec/dummy/db/migrate/` to the engine's `db/migrate/` so it ships with the gem.
3. Edit the migration file with proper `change` / `up` / `down` methods.
4. Consider: indexes (use `algorithm: :concurrently` on large tables with `disable_ddl_transaction!`), foreign keys (`validate: false` then validate separately), null constraints, defaults, JSONB columns (use `jsonb` type — the engine uses JSONB for `Document` / `Material` metadata).
5. Do **not** reference `Lcms::Engine::*` models inside the migration — use raw SQL or `execute` for data ops, since hosts may run the migration before model autoload.
6. Apply the migration against the dummy app:
   ```bash
   docker compose run --rm app sh -c 'cd spec/dummy && bundle exec rails db:migrate'
   docker compose run --rm -e RAILS_ENV=test app sh -c 'cd spec/dummy && bundle exec rails db:migrate'
   ```
7. Verify `db/schema.rb` was updated as expected.
8. Hand off to `migration-reviewer` for a production-safety check before committing.
