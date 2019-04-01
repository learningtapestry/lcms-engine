# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-webkit'
require 'capybara-screenshot/rspec'

Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.timeout = 20
  config.ignore_ssl_errors
  # NOTE: Do we need to raise them?
  # config.raise_javascript_errors = true
end

Capybara::Screenshot.prune_strategy = :keep_last_run
