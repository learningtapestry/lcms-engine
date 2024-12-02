# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'lcms/engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'lcms-engine'
  s.version = Lcms::Engine::VERSION
  s.authors = ['Alexander Kuznetsov', 'Abraham Sánchez', 'Rômulo Saksida']
  s.email = %w(paranoic.san@gmail.com abraham@learningtapestry.com rm@learningtapestry.com)
  s.homepage = 'https://github.com/learningtapestry/lcms-engine'
  s.summary = 'Rails engine for LCMS applications'
  s.description = 'Implements common components and features for Rails-based LCMS systems'
  s.license = 'Apache-2.0'
  s.metadata = {
    'homepage_uri' => 'https://github.com/learningtapestry/lcms-engine',
    'changelog_uri' => 'https://github.com/learningtapestry/lcms-engine/blob/master/CHANGELOG.md',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/learningtapestry/lcms-engine',
    'bug_tracker_uri' => 'https://github.com/learningtapestry/lcms-engine/issues'
  }

  s.files = `git ls-files`.split("\n")

  s.required_ruby_version = '~> 2.7'

  s.add_dependency 'activejob-retry', '~> 0.6.3'
  s.add_dependency 'active_model_serializers', '~> 0.10.10'
  s.add_dependency 'acts_as_list', '~> 1.0'
  s.add_dependency 'acts-as-taggable-on', '~> 7.0'
  s.add_dependency 'addressable', '~> 2.7'
  s.add_dependency 'airbrake', '~> 13.0'
  s.add_dependency 'autoprefixer-rails', '~> 9.7'
  s.add_dependency 'aws-sdk-rails', '~> 3.1'
  s.add_dependency 'aws-sdk-s3', '~> 1'
  s.add_dependency 'bitly', '~> 1.1', '>= 1.1.2'
  s.add_dependency 'bootstrap-sass', '~> 3.4'
  s.add_dependency 'bullet', '~> 6.1', '>= 6.1.0'
  s.add_dependency 'carrierwave', '~> 2.1'
  s.add_dependency 'ckeditor', '~> 5.1'
  s.add_dependency 'closure_tree', '~> 7.1'
  s.add_dependency 'combine_pdf', '~> 1.0'
  s.add_dependency 'daemons', '~> 1.3', '>= 1.3.1'
  s.add_dependency 'devise', '~> 4.7', '>= 4.7.1'
  s.add_dependency 'elasticsearch-dsl', '~> 0.1.9'
  s.add_dependency 'elasticsearch-model', '~> 7.0'
  s.add_dependency 'elasticsearch-persistence', '~> 7.0'
  s.add_dependency 'elasticsearch-rails', '~> 7.0'
  s.add_dependency 'fog-aws', '~> 3.5', '>= 3.5.2'
  s.add_dependency 'font-awesome-sass', '~> 5.12'
  s.add_dependency 'foundation-rails', '~> 6.6.2', '>= 6.6.1'
  s.add_dependency 'google-apis-drive_v3', '~> 0.46'
  s.add_dependency 'google-apis-script_v1', '~> 0.21'
  s.add_dependency 'hiredis', '~> 0.6.3'
  s.add_dependency 'httparty', '~> 0.18'
  s.add_dependency 'jbuilder', '~> 2.10'
  s.add_dependency 'jquery-rails', '~> 4.3', '>= 4.3.5'
  s.add_dependency 'js-routes', '~> 1.4', '>= 1.4.9'
  s.add_dependency 'lt-google-api', '~> 0.3'
  s.add_dependency 'lt-lcms', '~> 0.6'
  s.add_dependency 'migration_data', '~> 0.6'
  s.add_dependency 'mini_magick', '~> 4.10', '>= 4.10.1'
  s.add_dependency 'nested_form', '~> 0.3.2'
  s.add_dependency 'nikkou', '~> 0.0.5'
  s.add_dependency 'nokogiri', '~> 1.12', '>= 1.12.0'
  s.add_dependency 'oj', '~> 3.10', '>= 3.10.2'
  s.add_dependency 'oj_mimic_json', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'pandoc-ruby', '~> 2.0', '>= 2.0.2'
  s.add_dependency 'pdfjs_viewer-rails', '~> 0.3.1'
  s.add_dependency 'pg', '~> 1.2', '>= 1.2.2'
  s.add_dependency 'pg_search', '~> 2.3', '>= 2.3.2'
  s.add_dependency 'rack-mini-profiler', '~> 2.3', '>= 2.3.3'
  s.add_dependency 'rails', '~> 6.1.6', '>= 6.1.6.1'
  s.add_dependency 'ransack', '~> 2.3', '>= 2.3.2'
  s.add_dependency 'react-rails', '~> 2.6', '>= 2.6.1'
  s.add_dependency 'redis', '~> 4.1', '>= 4.1.3'
  s.add_dependency 'resque', '~> 2.0', '>= 2.0.0'
  s.add_dependency 'resque-scheduler', '~> 4.4', '>= 4.4.0'
  s.add_dependency 'rest-client', '~> 2.1', '>= 2.1.0'
  s.add_dependency 'retriable', '~> 3.1'
  s.add_dependency 'ruby-progressbar', '~> 1.10', '>= 1.10.1'
  s.add_dependency 'rubyzip', '~> 2'
  s.add_dependency 'sanitize', '~> 6.0.0'
  s.add_dependency 'sass-rails', '~> 6'
  s.add_dependency 'simple_form', '~> 5.0', '>= 5.0.2'
  s.add_dependency 'staccato', '~> 0.5.3'
  s.add_dependency 'truncate_html', '~> 0.9.3'
  s.add_dependency 'turbolinks', '~> 5.2', '>= 5.2.1'
  s.add_dependency 'validate_url', '~> 1.0', '>= 1.0.8'
  s.add_dependency 'virtus', '~> 1.0', '>= 1.0.5'
  s.add_dependency 'will_paginate', '~> 3.2', '>= 3.2.1'
  s.add_dependency 'will_paginate-bootstrap', '~> 1.0', '>= 1.0.2'
  s.add_dependency 'with_advisory_lock', '~> 4.6'

  s.add_development_dependency 'capybara', '~> 3.31'
  s.add_development_dependency 'database_cleaner-active_record', '~> 1.8'
  s.add_development_dependency 'dotenv-rails', '~> 2.2'
  s.add_development_dependency 'email_spec', '2.2.0'
  s.add_development_dependency 'factory_bot', '~> 5'
  s.add_development_dependency 'faker', '~> 2.1'
  s.add_development_dependency 'overcommit', '~> 0.57'
  s.add_development_dependency 'pry-byebug', '~> 3.7'
  s.add_development_dependency 'pry-rails', '~> 0.3.5'
  s.add_development_dependency 'rspec-rails', '~> 4.0.2'
  s.add_development_dependency 'rubocop', '~> 1.17'
  s.add_development_dependency 'sdoc', '~> 2'
  s.add_development_dependency 'seedbank', '~> 0.3'
  s.add_development_dependency 'selenium-webdriver', '~> 3.142', '>= 3.142.7'
  s.add_development_dependency 'shoulda-matchers', '~> 4.1'
  # Workaround for cc-test-reporter with SimpleCov 0.18.
  # Stop upgrading SimpleCov until the following issue will be resolved.
  # https://github.com/codeclimate/test-reporter/issues/418
  s.add_development_dependency 'simplecov', '< 0.18'
  s.add_development_dependency 'spring', '~> 2.1'
  s.add_development_dependency 'spring-commands-rspec', '~> 1.0'
  s.add_development_dependency 'traceroute', '~> 0.8'
  s.add_development_dependency 'webdrivers', '~> 4.0'
  s.add_development_dependency 'webpacker', '~> 5.0'
end
