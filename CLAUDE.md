# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`lcms-engine` is a **Rails Engine packaged as a Ruby gem** that provides common LCMS (Learning Content Management System) functionality. It is **not** a standalone application — it is mounted by host applications (e.g. Odell, Unbound ED, OpenSciEd) and consolidates shared LCMS code. A successor project `lcms-core` exists at `../../lcms-core/` as a rethink of this codebase.

All engine code is isolated under the `Lcms::Engine` namespace (`isolate_namespace Lcms::Engine` in `lib/lcms/engine/engine.rb`).

The dummy app under `spec/dummy/` is used solely to host the engine during development and testing.

## Technology Stack

- **Engine type**: Rails Engine (gem), `~> rails 8.1.0`
- **Ruby**: 3.3.9 (gemspec allows `~> 3.2, < 3.5`)
- **Database**: PostgreSQL (`pg`), with `pg_search` for full-text search and `hstore` extension
- **Search**: Elasticsearch 8.x (`elasticsearch-model`, `elasticsearch-persistence`, `elasticsearch-rails`, `elasticsearch-dsl`)
- **Queue**: Resque + resque-scheduler (Redis-backed); queue adapter is forced to `:resque` in the engine's `after_initialize`
- **Authentication**: Devise (`Lcms::Engine::User`)
- **Frontend**: Sprockets + cssbundling-rails (Sass) + jsbundling-rails, Bootstrap, CKEditor 5
- **PDF generation**: `wicked_pdf` (custom fork from `learningtapestry/wicked_pdf`, `puppeteer-support` branch) + `combine_pdf`
- **File storage**: CarrierWave + AWS S3 (`aws-sdk-s3`, `fog-aws`)
- **Google integration**: `google-apis-drive_v3`, `google-apis-script_v1`, `lt-google-api`
- **Type checking**: RBS + Steep
- **Testing**: RSpec, FactoryBot, Capybara + selenium-webdriver, shoulda-matchers, database_cleaner-active_record, mock_redis
- **Containerization**: Docker, Docker Compose

## Docker Architecture

The engine is developed and tested inside Docker. The compose file at `docker-compose.yml` is minimal — it starts `db`, `redis`, and an `app` container that mounts the repo and keeps a long-running shell.

### Docker Services

- **db**: PostgreSQL 18 (alpine) on port 5432, `POSTGRES_HOST_AUTH_METHOD=trust`
- **redis**: Redis 7 (alpine) on port 6379
- **app**: Development container running image `learningtapestry/lcms-engine:ruby-3.3.9-rails-8.1`. On start it runs `bundle install && yarn && tail -f /dev/null`. Bundle is cached in the named volume `bundle-ruby-3.3.9-rails-8.1`.

`spec/dummy/.env.docker` provides environment variables to the `app` container. `REDIS_URL` is overridden to `redis://redis:6379/1` in `docker-compose.yml`.

A separate file `docker-compose.ide.rails-8.1.yml` is provided for IDE-driven workflows; `docker-compose.personal.yml` is for per-developer overrides (not committed assumptions).

## Development Commands

All commands run inside the `app` container.

### Setup

```bash
# Start db, redis, and the app container in the background
docker compose create
docker compose start db redis

# Enable hstore + create the test database (one-time, inside the db container)
docker compose exec db sh -c "psql -U postgres -d template1 -c 'CREATE EXTENSION IF NOT EXISTS hstore;'"
docker compose exec db sh -c "psql -U postgres -c 'CREATE DATABASE lcms_engine_test;'"

docker compose start app
```

Before running anything that touches the dummy app, create `spec/dummy/.env.test` (use `spec/dummy/.env` as the template) — it is required for both `rails console` and the spec suite.

### Testing

```bash
# Run the full RSpec suite
docker compose run --rm app sh -c 'bundle exec rspec'

# Run a single spec file or line
docker compose run --rm app bundle exec rspec spec/path/to/file_spec.rb
docker compose run --rm app bundle exec rspec spec/path/to/file_spec.rb:42
```

Feature specs use Capybara with `selenium-webdriver` / `webdrivers` and need a working Chromedriver inside the container.

### RBS / Type checking

`Steepfile` checks `app/models/**/*.rb` and `lib` against signatures under `sig/` and `vendor/rbs`. RBS collection is locked in `rbs_collection.lock.yaml`.

```bash
# Run Steep
docker compose run --rm app bundle exec steep check

# Generate RBS for new models (run from spec/dummy)
docker compose run --rm app sh -c 'cd spec/dummy && bundle exec rails rbs_rails:generate_rbs_for_models'

# Generate RBS for a single non-model file
docker compose run --rm app sh -c 'bundle exec rbs prototype rb app/jobs/lcms/engine/integrations/webhook_call_job.rb \
  > sig/app/jobs/lcms/engine/integrations/webhook_call_job.rbs'
```

After generating model signatures inside `spec/dummy/sig`, copy the relevant ones to the engine's root `sig/` tree and drop the rest.

### Code Quality

```bash
# Rubocop (rubocop-rails-omakase config in .rubocop.yml; TargetRubyVersion 3.2)
docker compose run --rm app bundle exec rubocop
docker compose run --rm app bundle exec rubocop -a

# Frontend lints (run by overcommit PreCommit > CustomScript)
docker compose run --rm app yarn lint
```

### Git Hooks (overcommit)

`overcommit` is configured in `.overcommit.yml`. Pre-commit runs Rubocop, BundleCheck, LocalPathsInGemfile, ExecutePermissions, YamlSyntax, `yarn lint`, TrailingWhitespace, `steep check` and ShellCheck. Install hooks once with `bundle exec overcommit --install` inside the container.

### Building the Docker image

The dev image is multi-arch. To rebuild and push:

```bash
docker buildx build --platform linux/arm64/v8,linux/amd64 \
  -t learningtapestry/lcms-engine:ruby-3.3.9-rails-8.1 --push .
```

### Git Hooks

Git hooks live in `script/hooks/` and delegate to `overcommit` inside the `app` container. Install them once:

```bash
ln -sf ../../script/hooks/pre-commit .git/hooks/pre-commit
ln -sf ../../script/hooks/pre-push   .git/hooks/pre-push
```

They run:

- **pre-commit** — `docker compose run --rm app overcommit --run`. Per `.overcommit.yml` this covers RuboCop, BundleCheck, LocalPathsInGemfile, ExecutePermissions, YamlSyntax, `yarn lint`, TrailingWhitespace, `steep check`, and ShellCheck.
- **pre-push** — `docker compose run --rm app overcommit --run pre_push` (RSpec suite).

Note: `docker compose run` overrides the service's default startup command (`bundle install && yarn && tail -f /dev/null`), so the hooks won't re-run those each time.

## Engine Architecture

### Engine entry point

`lib/lcms/engine/engine.rb` does the work normally split across initializers in an app:

- `isolate_namespace Lcms::Engine`
- Adds `lib/` and `app/jobs/concerns` to autoload paths
- Loads locale files from `config/locales/**/*.yml`
- Appends Bootstrap-icons and FontAwesome webfont paths to `config.assets.paths`
- In `after_initialize`: pins `config.active_job.queue_adapter = :resque`; in dev/test, enables Bullet if the gem is loaded
- In `to_prepare`: requires any decorator files matching `app/decorators/**/*_decorator*.rb` or `app/**/lcms/engine/*_decorator*.rb` in the **host app** (this is how clients customize engine classes — see "Override and extension" below)
- `append_migrations` initializer exposes the engine's `db/migrate` paths to the host app
- Assets initializer precompiles `lcms_engine_manifest.js` and `ckeditor/config.js` and mounts a `Rack::Static` middleware at `/lcms-engine-assets`

### Namespacing convention

All engine Ruby code lives under `Lcms::Engine::*`:

- `app/models/lcms/engine/*` — domain models
- `app/controllers/lcms/`, `app/jobs/lcms/engine/*`, `app/services/lcms/engine/*`
- Top-level concerns (`app/models/concerns/`, `app/controllers/concerns/`, `app/jobs/concerns/`) are intentionally unnamespaced so host apps can include them too.

When generating a new model/service/job, place it under the matching `lcms/engine/` directory and wrap it in `module Lcms; module Engine; ...; end; end`.

### Core Domain Models (`app/models/lcms/engine/`)

**Documents and materials**
- `Document` — imported lesson documents (typically from Google Docs)
- `DocumentPart` — multi-format rendered chunks of a document (gdoc, PDF)
- `DocumentBundle` — aggregations of documents for bundled output
- `Material` — supporting materials
- `ReadingAssignmentAuthor`, `ReadingAssignmentText` — reading-assignment domain

**Curriculum hierarchy**
- `Resource` — curriculum tree (grades → modules → units → lessons) using `closure_tree`; has join models `ResourceAdditionalResource`, `ResourceRelatedResource`, `ResourceStandard`, `ResourceReadingAssignment`
- `Curriculum`

**Standards & tagging**
- `Standard`, `StandardLink` — educational standards
- `Tag`, `Tagging` — backed by `acts-as-taggable-on`

**Auth & site content**
- `User` (Devise), `AccessCode`
- `StaffMember`, `LeadershipPost`, `Author`, `CopyrightAttribution`, `SocialThumbnail`, `Settings`

**Integrations**
- `Lcms::Engine::Integrations::*` — see `app/models/lcms/engine/integrations/`

### Services (`app/services/lcms/engine/`)

- **Import**: `ImportService` (base), `StandardsImportService`
- **Document/material build**: `DocumentBuildService`, `MaterialBuildService`, `DocumentGenerator`, `MaterialPreviewGenerator`
- **PDF / bundle**: `BundleGenerator`, `LessonsPdfBundler`, `LessonsGdocBundler`
- **Math & sanitization**: `EmbedEquations`, `HtmlSanitizer`
- **External systems**: `Google::*` services, `S3Service`, `LtiExporter`
- **Misc**: `BulkEditResourcesService`, `GenerateHierarchicalPositions`, `ReactMaterialsResolver`

### Background Jobs (`app/jobs/lcms/engine/`)

All inherit from `Lcms::Engine::ApplicationJob` and run via Resque:

- **Documents**: `DocumentParseJob`, `DocumentGenerateJob`, `DocumentGeneratePdfJob`, `DocumentGenerateGdocJob`, `DocumentBundleGenerateJob`
- **Materials**: `MaterialParseJob`, `MaterialGenerateJob`, `MaterialGeneratePdfJob`, `MaterialGenerateGdocJob`
- **Integrations**: `app/jobs/lcms/engine/integrations/*` (e.g. webhook delivery)

### DocTemplate (`lib/doc_template/`, `lib/doc_template.rb`)

Custom templating layer for parsing Google Docs into rendered output.

- **Configuration**: `config/lcms.yml` in the host app, merged with the `DEFAULTS` hash in `lib/doc_template.rb`. Host apps override entries like `bundles`, `metadata.context`, `metadata.service`, `queries.document`, `queries.material`, `sanitizer`.
- **Top-level constants**:
  - `FULL_TAG = /\[([^\]:\s]*)?\s*:?\s*([^\]]*?)?\]/mo`
  - `START_TAG`, `STARTTAG_XPATH`, `ENDTAG_XPATH`
- **Submodules**: `DocTemplate::Document`, `DocTemplate::Template`, `DocTemplate::Tables::*`, `DocTemplate::Tags::*`, `DocTemplate::Objects::*`, `DocTemplate::XpathFunctions`

When extending the parser, add tag classes under `lib/doc_template/tags/` and register them through the `Template` class rather than monkey-patching.

### Other `lib/` modules

- `lib/document_exporter/` — exporters for gdoc / other targets
- `lib/document_renderer/` — output rendering helpers
- `lib/lti/` — LTI integration
- `lib/lt/` — Learning Tapestry shared helpers (note: distinct from the external `lt-*` gems)
- `lib/generators/` — Rails generators (`lcms:engine:install`, etc.)
- `lib/tasks/` — Rake tasks (e.g. `lcms_engine:load_default_schema`, `lcms_engine:seed_data`)

### Host-app contract

A host app installs and uses the engine via:

```ruby
# Gemfile
gem 'lcms-engine'

# routes.rb
mount Lcms::Engine::Engine, at: '/lcms'   # mounting under an alias is NOT supported

# initial setup
bin/rails g lcms:engine:install
bin/rails lcms_engine:load_default_schema
bin/rails lcms_engine:seed_data
```

The host app must explicitly pin `config.active_job.queue_adapter = :resque` (and optionally `queue_name_prefix`) in its environment files to keep parity with the engine.

Devise routes from the engine can be redefined in the host app by setting `DEVISE_ROUTES_REDEFINED=true` — see `README.md` § "Host app routes" for the two supported patterns.

## Override and Extension

This engine is consumed by multiple client apps. Three customization tiers (lowest to highest impact) — see `README.md` for full rationale:

1. **Decorators** (`app/decorators/**/*_decorator*.rb` in the host app). The engine auto-requires these in `to_prepare`. Use `class_eval` / `module_eval` to tweak engine classes for small refinements.
2. **Concerns**: extract shared behavior into a module under `lib/concerns/` (e.g. `lib/concerns/doc_template/template.rb`), include it in the engine class, and re-include it from the host class. Use when the change is larger but still cooperative.
3. **Full override**: drop a file with the same path and class name in the host app. Rails autoloading prefers the host app's copy. Last-resort only.

When working in the engine, **prefer adding extension points (config hooks, configurable class names in `DocTemplate.config`) over inlining behavior** so host apps can override without forking. The `DEFAULTS` hash in `lib/doc_template.rb` is the canonical example.

Do not extract small pieces of host-app code into new gems. If something is reusable across client apps, move it into this engine; otherwise leave it in the host app. See the `README.md` § "Use of separate gems".

## Testing Strategy (`spec/`)

- `spec/dummy/` — minimal Rails app that mounts the engine. Required for ActiveRecord-backed specs and for `rails console`.
- `spec/factories/` — FactoryBot factories
- `spec/models/`, `spec/services/`, `spec/queries/`, `spec/controllers/`, `spec/requests/`, `spec/features/`, `spec/lib/`, `spec/forms/`, `spec/entities/`, `spec/helpers/`
- `spec/support/` — shared examples, configuration, helpers
- `spec/fixtures/` — fixture files

`database_cleaner-active_record` handles DB cleanup. `mock_redis` stands in for Redis in unit specs.

`spec_helper.rb` is autoloaded via `.rspec` (`--require spec_helper`).

## Configuration Files

- `lcms-engine.gemspec` — gem definition and all runtime / dev dependencies (single source of truth)
- `Gemfile` — points at `gemspec` plus the `wicked_pdf` git fork
- `.ruby-version` — `3.3.9`
- `.rubocop.yml` — `rubocop-rails-omakase` base, `NewCops: enable`, `TargetRubyVersion: 3.2`, `LineLength.Max: 120`
- `Steepfile` — RBS check targets
- `rbs_collection.yaml`, `rbs_collection.lock.yaml` — RBS dependency lockfile
- `package.json`, `yarn.lock`, `postcss.config.js` — frontend tooling
- `Dockerfile`, `docker-compose.yml`, `docker-compose.ide.rails-8.1.yml`, `docker-compose.personal.yml`
- `db/schema.rb`, `db/migrate/`, `db/seeds.rb`, `db/seeds/` — schema and seeds shared with host apps via the `append_migrations` initializer

## Docs

Detailed engine-specific docs live in `docs/`:

- [Environment variables](docs/env-variables.md)
- [Google Cloud setup](docs/google-cloud-platform-setup.md)
- [How to build and publish](docs/how-to-build-and-publish.md)
- [PDF generation](docs/pdf-generation.md)
- [Override controllers for Rails 7](docs/override-controllers-for-rails-7.md)
- [CKEditor usage](docs/ckeditor-usage.md)

## Git Commit Guidelines

**IMPORTANT**: All commit messages MUST be written in English.

### Commit Message Format

First line is the subject — a short summary starting with a capital letter. After a blank line, add details about changes using a bullet list.

### Git Commit Rules

- Always use `git commit -s` to add a `Signed-off-by` line
- NEVER add a `Co-Authored-By` line to commits

### Example

```
Add user authentication module

- Implement JWT token generation and validation
- Add login and logout endpoints
- Create middleware for protected routes
- Add password hashing with bcrypt
```

## Code Style Guidelines

**IMPORTANT**: All Ruby code MUST follow the Rubocop rules in `.rubocop.yml`. The project uses the `rubocop-rails-omakase` style guide with these notable settings:

- `TargetRubyVersion: 3.2` (gem supports `~> 3.2, < 3.5`)
- `NewCops: enable`
- `Layout/LineLength.Max: 120`
- `Gemspec/DevelopmentDependencies` set to `EnforcedStyle: gemspec` — keep dev dependencies in `lcms-engine.gemspec`, not the `Gemfile`

Add `# frozen_string_literal: true` to every new Ruby file.

Run Rubocop before committing:

```bash
docker compose run --rm app bundle exec rubocop
docker compose run --rm app bundle exec rubocop -a
```

## Debug Output Pattern

The user uses `puts ":>..."` as a debug pattern. Before committing, search for and remove any such lines:

```bash
grep -rn 'puts ":>' app lib spec
```

## Release / Publishing

This gem is published to RubyGems. The release flow is documented in [`docs/how-to-build-and-publish.md`](docs/how-to-build-and-publish.md). `rubygems_mfa_required` is set in the gemspec metadata.

Active branches:

| Branch    | Rails version |
|-----------|---------------|
| master    | Rails 7.0     |
| rails-6.1 | Rails 6.1     |
| rails-8.1 | Rails 8.1 (current working branch) |