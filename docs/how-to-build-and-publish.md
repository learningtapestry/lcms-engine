# How to build and publish gem

Increase the version in `lib/lcms/engine/version.rb` and update `CHANGELOG.md`.

Build the gem
```bash
$ gem build lcms-engine.gemspec
```

Publish it replacing `x-y-z` with correct version number.
```bash
$ gem signin
$ gem push lcms-engine-x-y-z.gem
```
