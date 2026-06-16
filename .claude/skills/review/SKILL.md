---
name: review
description: Review the current git diff in the lcms-engine gem for correctness, security, N+1 queries, engine-namespacing / host-extensibility violations, style problems, RBS gaps, and missing test coverage. Uses the code-reviewer agent and runs Rubocop + Steep (and Brakeman if available).
---

Use the `code-reviewer` agent to review the current git diff.

Run `git diff HEAD` (or `git diff <base>...HEAD`) to see what changed, then review all modified Ruby files for:
- Engine namespacing (`Lcms::Engine::*` for everything under `app/{models,services,jobs,forms,presenters,queries,entities,controllers}/lcms/engine/`)
- Host-app extensibility (decorator-friendly, config-knob over hardcoding, no host-specific assumptions)
- Security issues — delegate to the `security-auditor` agent (Brakeman is not bundled; auditor handles ad-hoc install)
- N+1 queries and performance problems (especially around `closure_tree` Resource traversal and `Document`/`Material` parts)
- Rails / engine conventions (Resque jobs inheriting `Lcms::Engine::ApplicationJob`, services / queries / forms in the right layer)
- Style violations against `.rubocop.yml` (NOT rubocop-rails-omakase — single quotes, `frozen_string_literal: true`, line length 120)
- RBS coverage for changed files under `app/models/**` and `lib/**`
- Missing test coverage (mirror source path under `spec/`)

After reviewing, run these on the `app` service:
```bash
docker compose run --rm app bundle exec rubocop
docker compose run --rm app bundle exec steep check
# Optionally — Brakeman is not in the gemspec by default:
docker compose run --rm app sh -c 'gem list brakeman | grep -q brakeman && cd spec/dummy && bundle exec brakeman --no-pager ../.. || echo "brakeman not installed"'
```

For database migration changes (`db/migrate/`), also hand off to `migration-reviewer`.

Output a structured review with 🔴 Critical / 🟡 Important / 🟢 Minor sections, plus a `✅ Good patterns` callout.
