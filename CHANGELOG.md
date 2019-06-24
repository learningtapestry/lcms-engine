# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.2.0

### Added
- Add cache to index pages: Access codes, Standards, Users [@paranoicsan](https://github.com/paranoicsan)
- Add `reimported_at` field to Document object [@paranoicsan](https://github.com/paranoicsan)

### Changes
- Replace [capybara-selenium](https://github.com/dsaenztagarro/capybara-selenium) with [selenium-webdriver](https://rubygems.org/gems/selenium-webdriver) [@paranoicsan](https://github.com/paranoicsan)

### Removed
- Remove explicit cache setup. Should be defined in the host application [@paranoicsan](https://github.com/paranoicsan)
- Remove [newrelic_rpm gem](https://github.com/newrelic/rpm). One should be added directly to a host application [@paranoicsan](https://github.com/paranoicsan)
- Remove [readthis gem](https://github.com/sorentwo/readthis). Rails 5.2 has built-in replacement [@paranoicsan](https://github.com/paranoicsan)
