---
name: build-image
description: Build the development Docker image locally for the current platform only (no push). Use after updating gems (Gemfile / Gemfile.lock / lcms-engine.gemspec) or system dependencies when you only need the image on your own machine.
---

Build the development Docker image locally for the current platform only (no push to registry).

Use this after updating gems (Gemfile / Gemfile.lock / lcms-engine.gemspec) or system dependencies when you only need the image on your own machine.

Run the following command:

```bash
docker buildx build \
  -f Dockerfile \
  -t learningtapestry/lcms-engine:ruby-3.3.9-rails-8.1 \
  --load .
```

Notes:
- `--load` builds for the current platform only and loads the image into the local Docker daemon.
- Multi-platform builds cannot be combined with `--load`; use `/build-image-push` when a multi-arch image is needed.
- The tag `learningtapestry/lcms-engine:ruby-3.3.9-rails-8.1` is what `docker-compose.yml` references on the `rails-8.1` branch. If the gemspec's Ruby / Rails version changed, bump the tag here, in `docker-compose.yml`, and in the build-image-push skill so all three stay in sync.

After the build finishes, show the image info:

```bash
docker image ls learningtapestry/lcms-engine:ruby-3.3.9-rails-8.1
```
