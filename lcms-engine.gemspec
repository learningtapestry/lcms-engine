# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'lcms/engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'lcms-engine'
  s.version = Lcms::Engine::VERSION
  s.authors = ['Alexander Kuznetsov', 'Abraham Sánchez', 'Rômulo Saksida']
  s.email = %w(alexander@learningtapestry.com abraham@learningtapestry.com rm@learningtapestry.com)
  s.homepage = 'https://github.com/learningtapestry/lcms-engine'
  s.summary = 'Rails engine for LCMS applications'
  s.description = 'Implements common components and features for Rails-based LCMS systems'
  s.license = 'Apache-2.0'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '>= 2.5'

  s.add_dependency 'active_model_serializers', '~> 0.10.10'
  s.add_dependency 'activejob-retry', '~> 0.6.3'
  s.add_dependency 'acts-as-taggable-on', '~> 6.5.0'
  s.add_dependency 'acts_as_list', '~> 1.0.0'
  s.add_dependency 'addressable', '~> 2.7.0'
  s.add_dependency 'airbrake', '~> 10.0.1'
  s.add_dependency 'autoprefixer-rails', '~> 9.7.4'
  s.add_dependency 'aws-sdk-rails', '~> 1.0'
  s.add_dependency 'bitly', '~> 1.1.2'
  s.add_dependency 'bootstrap-sass', '~> 3.4.1'
  s.add_dependency 'bullet', '~> 6.1.0'
  s.add_dependency 'carrierwave', '~> 2.1.0'
  s.add_dependency 'ckeditor', '~> 4.3.0'
  s.add_dependency 'closure_tree', '~> 7.1.0'
  s.add_dependency 'combine_pdf', '~> 1.0.16'
  s.add_dependency 'daemons', '~> 1.3.1'
  s.add_dependency 'devise', '~> 4.7.1'
  s.add_dependency 'elasticsearch-dsl', '~> 0.1.9'
  s.add_dependency 'elasticsearch-model', '~> 7.0.0'
  s.add_dependency 'elasticsearch-persistence', '~> 7.0.0'
  s.add_dependency 'elasticsearch-rails', '~> 7.0.0'
  s.add_dependency 'fog-aws', '~> 3.5.2'
  s.add_dependency 'font-awesome-sass', '~> 5.12.0'
  s.add_dependency 'foundation-rails', '~> 6.6.1.0'
  s.add_dependency 'google-api-client', '~> 0.37.1'
  s.add_dependency 'heap', '~> 1'
  s.add_dependency 'hiredis', '~> 0.6.3'
  s.add_dependency 'httparty', '~> 0.18.0'
  s.add_dependency 'i18n-js', '~> 3.6.0'
  s.add_dependency 'jbuilder', '~> 2.10.0'
  s.add_dependency 'jquery-rails', '~> 4.3.5'
  s.add_dependency 'js-routes', '~> 1.4.9'
  s.add_dependency 'lt-google-api', '~> 0.1.1'
  s.add_dependency 'lt-lcms', '~> 0.2.0'
  s.add_dependency 'migration_data', '~> 0.6.0'
  s.add_dependency 'mini_magick', '~> 4.10.1'
  s.add_dependency 'nested_form', '~> 0.3.2'
  s.add_dependency 'newrelic_rpm', '~> 6.9.0.363'
  s.add_dependency 'nikkou', '~> 0.0.5'
  s.add_dependency 'nokogiri', '~> 1.10.8'
  s.add_dependency 'oj', '~> 3.10.2'
  s.add_dependency 'oj_mimic_json', '~> 1.0.1'
  s.add_dependency 'pandoc-ruby', '~> 2.0.2'
  s.add_dependency 'pdfjs_viewer-rails', '~> 0.3.1'
  s.add_dependency 'pg', '~> 1.2.2'
  s.add_dependency 'pg_search', '~> 2.3.2'
  s.add_dependency 'rack-mini-profiler', '~> 1.1.6'
  s.add_dependency 'rails', '~> 5.2.4.1'
  s.add_dependency 'rails-assets-classnames', '~> 2.2.5'
  s.add_dependency 'rails-assets-es6-promise', '~> 4.2.4'
  s.add_dependency 'rails-assets-eventemitter3', '~> 3.1.2'
  s.add_dependency 'rails-assets-fetch', '~> 3.0.0'
  s.add_dependency 'rails-assets-jstree', '~> 3.3.8'
  s.add_dependency 'rails-assets-knockout', '~> 3.5.0'
  s.add_dependency 'rails-assets-lodash', '~> 4.17.15'
  s.add_dependency 'rails-assets-selectize', '~> 0.12.6'
  s.add_dependency 'ransack', '~> 2.3.2'
  s.add_dependency 'react-rails', '~> 2.6.1'
  s.add_dependency 'readthis', '~> 2.2.0'
  s.add_dependency 'redis', '~> 4.1.3'
  s.add_dependency 'resque', '~> 2.0.0'
  s.add_dependency 'resque-scheduler', '~> 4.4.0'
  s.add_dependency 'rest-client', '~> 2.1.0'
  s.add_dependency 'ruby-progressbar', '~> 1.10.1'
  s.add_dependency 'rubyzip', '~> 2.2.0'
  s.add_dependency 'sanitize', '~> 5.1.0'
  s.add_dependency 'sass-rails', '~> 5.1.0'
  s.add_dependency 'simple_form', '~> 5.0.2'
  s.add_dependency 'staccato', '~> 0.5.3'
  s.add_dependency 'truncate_html', '~> 0.9.3'
  s.add_dependency 'turbolinks', '~> 5.2.1'
  s.add_dependency 'validate_url', '~> 1.0.8'
  s.add_dependency 'virtus', '~> 1.0.5'
  s.add_dependency 'will_paginate', '~> 3.2.1'
  s.add_dependency 'will_paginate-bootstrap', '~> 1.0.2'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner-active_record', '~> 1.8'
  s.add_development_dependency 'dotenv-rails'
  s.add_development_dependency 'email_spec'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'overcommit', '~> 0.48.1'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '~> 0.59.2'
  s.add_development_dependency 'sdoc'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'spring'
  s.add_development_dependency 'spring-commands-rspec'
  s.add_development_dependency 'traceroute'
  s.add_development_dependency 'webdrivers', '~> 4.0'
  s.add_development_dependency 'webpacker', '~> 4.0.6'
end
