---
name: test
description: Write RSpec tests for a specified file or feature in the lcms-engine gem using the test-writer agent. Pass the file path or feature description as arguments. Covers happy path, edge cases, error handling.
---

Use the `test-writer` agent to write RSpec tests for: $ARGUMENTS

If no file is specified, ask which file needs tests.

Compose service is `app`. This project's `.rspec` only carries `--require spec_helper` — no `--pattern` override needed.

Steps:
1. Read the source file (note its namespace — engine classes live under `Lcms::Engine::*`).
2. Check `spec/factories/` for existing factories to reuse (`Document`, `Material`, `Resource`, `User`, `Standard`, etc.). New factories for engine classes need `class: 'Lcms::Engine::Foo'`.
3. Check `spec/support/` for shared examples and helpers.
4. Write the spec under the mirrored path:
   - `app/models/lcms/engine/document.rb` → `spec/models/lcms/engine/document_spec.rb`
   - `app/services/lcms/engine/import_service.rb` → `spec/services/lcms/engine/import_service_spec.rb`
   - `lib/doc_template/template.rb` → `spec/lib/doc_template/template_spec.rb`
5. Cover happy path, edge cases, error handling. Use `described_class`, `let`, `subject` per project convention.
6. Run the new spec:
   ```bash
   docker compose run --rm app bundle exec rspec spec/path/to/new_spec.rb
   ```
7. Follow project style: single quotes for plain strings, `# frozen_string_literal: true` at the top, percent literals with parentheses.
