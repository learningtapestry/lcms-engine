# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/learningtapestry/lcms-engine/compare/v0.4.2...HEAD)

## [0.4.2](https://github.com/learningtapestry/lcms-engine/compare/v0.4.1...v0.4.2) - 2022.10.18

### Changed

- Allow `ImportStatus` page customization - [@paranoicsan](https://github.com/paranoicsan)

## [0.4.1](https://github.com/learningtapestry/lcms-engine/compare/v0.4.0...v0.4.1) - 2022.10.13

### Changed

- `Lcms::Engine::AdminMaterialsQuery` now filters by metadata in case-insensitive way  - [@paranoicsan](https://github.com/paranoicsan)

## [0.4.0](https://github.com/learningtapestry/lcms-engine/compare/v0.3.1...v0.4.0) - 2022.09.28

### Added

- Bump Rails to 6.1.7 - [@paranoicsan](https://github.com/paranoicsan)
- Bump lt-google-api to 0.2.4 - [@paranoicsan](https://github.com/paranoicsan)
- Bump lt-lcms to 0.4.4 - [@paranoicsan](https://github.com/paranoicsan)
- Explicitly skip indexing via ElasticSearch for objects which include Lcms::Engine::Searchable concern - [@paranoicsan](https://github.com/paranoicsan)
- Replace sass-lint to stylelint NodeJS package - [@paranoicsan](https://github.com/paranoicsan)
- Bump webpacker gem (and @rails/webpacker package) - [@paranoicsan](https://github.com/paranoicsan)
- `Lcms::Engine::S3Service.upload` method now accepts options Hash to be passed to AWS S3 resource - [@paranoicsan](https://github.com/paranoicsan)
- Explicitly added following packages: react-tagsinput, jstree, jquery and foundation-sites - [@paranoicsan](https://github.com/paranoicsan)
- Bump CKEditor to 5.1 - [@paranoicsan](https://github.com/paranoicsan)

### Changed

- [BREAKING] `DocumentError` has been moved under `Lcms::Engine` namespace and now looks like `Lcms::Engine::DocumentError` - [@paranoicsan](https://github.com/paranoicsan)
- [BREAKING] `MaterialError` has been moved under `Lcms::Engine` namespace and now looks like `Lcms::Engine::MaterialError` - [@paranoicsan](https://github.com/paranoicsan)
- [BREAKING] JS and CSS files have been renamed: added `lcms_engine_` prefix - [@paranoicsan](https://github.com/paranoicsan)
- Updated `google:setup_auth` rake task to work with _Web Application_ OAuth client ID - [@paranoicsan](https://github.com/paranoicsan)
- Dropped Rails 4.2 support
- Post-processing with Google App Script now shows Google Document ID in case of failure - [@paranoicsan](https://github.com/paranoicsan)

### Removed

- [BREAKING] Remove `Lcms::Engine::Component` model - [@paranoicsan](https://github.com/paranoicsan)
- [BREAKING] Drop support to Ruby bellow 2.7 - [@paranoicsan](https://github.com/paranoicsan)
- [BREAKING] Removed SocialMediaPresenter and a couple of legacy connected methods and views

## [0.3.1](https://github.com/learningtapestry/lcms-engine/compare/v0.3.0...v0.3.1) - 2021.02.12

### Fixed

- StrongParameters issues - [@paranoicsan](https://github.com/paranoicsan)
- Font Awesome Icons issues - [@paranoicsan](https://github.com/paranoicsan)
- Correctly search for a queued nested ActiveJob - [@paranoicsan](https://github.com/paranoicsan)
- Remove unnecessary redis key deletion - [@aderyabin](https://github.com/aderyabin)

### Added

- Explicitly import lodash (To prevent errors in LCMS projects) - [@paranoicsan](https://github.com/paranoicsan)

### Removed

- [BREAKING] Remove `Lcms::Engine::Component` model - [@paranoicsan](https://github.com/paranoicsan)
- [BREAKING] Remove `Lcms::Engine::Migration` class - [@paranoicsan](https://github.com/paranoicsan)
- Remove 'whoami' route - [@paranoicsan](https://github.com/paranoicsan)
- [BREAKING] Remove a bunch of `Lcms::Engine::Admin::AdminController` class methods - [@paranoicsan](https://github.com/paranoicsan)

## [0.3.0](https://github.com/learningtapestry/lcms-engine/compare/v0.2.0...v0.3.0) - 2020.08.19

### Added
- [Update gems and NodeJS packages](https://github.com/learningtapestry/lcms-engine/pull/133) to address high severity security issues [@paranoicsan](https://github.com/paranoicsan)
- Possibility to extend permitted params for Resource object [@paranoicsan](https://github.com/paranoicsan)

### Changed
- Introduced method `lcms_engine_javascript_pack_tag` to be used instead of `javascript_pack_tag` when one needs to include the JS assets from the engine [@paranoicsan](https://github.com/paranoicsan)

### Fixed
- Fix case insensitive metadata table HTML header searching [@shlag3n](https://github.com/shlag3n)

### Removed

- [BREAKING] Remove `Page` model
- Remove all gems from rails-assets repo
- [BREAKING] Remove `Thumbnail` services and classes
- Remove Google and Heap analytics code
- Remove unused routes used in UI part
- [BREAKING] Remove unused controllers
- Remove CSS stylesheets for UI part
- Remove fonts

## [0.2.0](https://github.com/learningtapestry/lcms-engine/compare/v0.1.2...v0.2.0) - 2020.04.27

### Added
- Add cache to index pages: Access codes, Standards, Users [@paranoicsan](https://github.com/paranoicsan)
- Add `reimported_at` field to Document object [@paranoicsan](https://github.com/paranoicsan)

### Changes
- [BREAKING] Bump Rails from 4.2 to 5.2 [@paranoicsan](https://github.com/paranoicsan), [@rradonic](https://github.com/rradonic)
- Bump rubyzip from 1.3 to 2 and stick it to version 2 and above

### Removed
- Remove explicit cache setup. Should be defined in the host application [@paranoicsan](https://github.com/paranoicsan)
- Remove [newrelic_rpm gem](https://github.com/newrelic/rpm). One should be added directly to a host application [@paranoicsan](https://github.com/paranoicsan)
- Remove [readthis gem](https://github.com/sorentwo/readthis). Rails 5.2 has built-in replacement [@paranoicsan](https://github.com/paranoicsan)

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
