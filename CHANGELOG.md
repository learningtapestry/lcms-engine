# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/learningtapestry/lcms-engine/compare/v0.1.4...HEAD)

## [0.1.4](https://github.com/learningtapestry/lcms-engine/compare/v0.1.3...v0.1.4) - 2020.08.20

### Changed

- bigdecimal gem is locked to 1.4.x version to keep compatibility with Rails 4 [@paranoicsan](https://github.com/paranoicsan)

## [0.1.3](https://github.com/learningtapestry/lcms-engine/compare/v0.1.2...v0.1.3) - 2020.08.19

### Changed
- [Update gems and NodeJS packages](https://github.com/learningtapestry/lcms-engine/pull/134) to address high severity security issues
- Add possibility to [extend permitted parameters](https://github.com/learningtapestry/lcms-engine/pull/114) inside decorators [@paranoicsan](https://github.com/paranoicsan)
- Introduced method `lcms_engine_javascript_pack_tag` to be used instead of `javascript_pack_tag` when one needs to include the JS assets from the engine [@paranoicsan](https://github.com/paranoicsan)

### Fixed
- [Fix missing content](https://github.com/learningtapestry/lcms-engine/pull/132) while sanitizing source HTML [@paranoicsan](https://github.com/paranoicsan)
- Fix case insensitive metadata table HTML header searching [@shlag3n](https://github.com/shlag3n)

## [0.1.2](https://github.com/learningtapestry/lcms-engine/compare/v0.1.0...v0.1.2) - 2020.04.23

### Added
- Add Docker support [@paranoicsan](https://github.com/paranoicsan)

### Changed
- Assets optimization [@paranoicsan](https://github.com/paranoicsan)
- Replace [capybara-selenium](https://github.com/dsaenztagarro/capybara-selenium) with [selenium-webdriver](https://rubygems.org/gems/selenium-webdriver) [@paranoicsan](https://github.com/paranoicsan)

### Removed
- Remove [I18n.js gem](https://github.com/fnando/i18n-js) [@paranoicsan](https://github.com/paranoicsan)

### Fixed
- Fix preview path on admin panel documents and materials index page [@paranoicsan](https://github.com/paranoicsan)
- Fix parse loop when content of the tag  contains tag name [@paranoicsan](https://github.com/paranoicsan)
- Fix possible grade leading zeros [@shlag3n](https://github.com/shlag3n)
- Fix nested jobs concern [@shlag3n](https://github.com/shlag3n)

## [0.1.0] - 2020.01.13

- Initial  release
