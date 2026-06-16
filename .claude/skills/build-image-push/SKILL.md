---
name: build-image-push
description: Build a multi-platform (linux/amd64, linux/arm64) development Docker image and push it to Docker Hub. Use after updating gems (Gemfile / Gemfile.lock / lcms-engine.gemspec) or system dependencies when the new image must be available to other developers / CI.
---

Build a multi-platform (linux/amd64, linux/arm64) development Docker image and push it to Docker Hub.

Use this after updating gems (Gemfile / Gemfile.lock / lcms-engine.gemspec) or system dependencies when the new image must be available to other developers / CI.

Assumptions:
- The user is already logged in to Docker Hub (`docker login`).
- The Docker Hub repository is `learningtapestry/lcms-engine`.
- A buildx builder that supports multi-platform builds already exists. If not, create it once:
  ```bash
  docker buildx create --name multiplatform-builder --use
  ```

Run the following command to build and push the multi-platform image:

```bash
docker buildx build \
  --platform linux/arm64/v8,linux/amd64 \
  -f Dockerfile \
  -t learningtapestry/lcms-engine:ruby-3.3.9-rails-8.1 \
  --push .
```

Notes:
- `--push` uploads the image to Docker Hub; it will NOT be loaded into the local Docker daemon (buildx limitation for multi-platform builds).
- If you need the freshly built image available locally for `docker compose`, run `/build-image` afterwards — it will reuse the buildx cache and load the single-platform image into the local daemon quickly.
- Never pass `--push` together with tags that should stay local.
- If authentication fails, ask the user to run `docker login` and retry.
- The image tag encodes the Ruby + Rails combo (e.g. `ruby-3.3.9-rails-8.1`). When bumping either, update the tag here, in `/build-image`, and in `docker-compose.yml` (and the `bundle-ruby-3.3.9-rails-8.1` volume name) so all references stay consistent.
