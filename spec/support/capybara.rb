# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  params = { timeout: 180, window_size: [1280, 1024] }
  Capybara::Poltergeist::Driver.new app, params
end

Capybara.default_max_wait_time = 3
Capybara.javascript_driver = :poltergeist
