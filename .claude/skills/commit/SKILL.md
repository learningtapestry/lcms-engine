---
name: commit
description: Run all pre-commit quality checks (Rubocop, Steep, security, YAML syntax, debug-output cleanup, relevant specs) before committing changes to the lcms-engine gem. Use before creating a git commit to ensure code quality.
---

Use the `pre-commit` agent to run all quality checks before committing.

Compose service is `app` (no separate `test` / `rails` service).

Run in order:
1. `docker compose run --rm app bundle exec rubocop -a` — auto-fix style
2. `docker compose run --rm app bundle exec rubocop` — check remaining violations
3. `docker compose run --rm app bundle exec steep check` — RBS / Steep type check
4. Delegate to `security-auditor` — Brakeman is not bundled by default; the auditor will run it ad hoc when relevant
5. Check YAML syntax for any changed config files
6. Run `grep -rn 'puts ":>' app lib spec` and remove any debug output
7. Run specs for modified files:
   ```bash
   docker compose run --rm app bundle exec rspec spec/path/to/file_spec.rb
   ```
   (No `--pattern` override needed — `.rspec` only carries `--require spec_helper`.)

Alternatively, if `overcommit` hooks are installed, the canonical gate is:
```bash
docker compose run --rm app bundle exec overcommit --run
```

Then show `git status` and suggest a commit message following the project format:
- English only
- Short capitalized subject line
- Blank line + bullet list of changes
- Remind to use: `git commit -s`
- NEVER suggest `Co-Authored-By`
