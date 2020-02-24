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

  s.add_dependency 'active_model_serializers'
  s.add_dependency 'activejob-retry'
  s.add_dependency 'acts-as-taggable-on'
  s.add_dependency 'acts_as_list'
  s.add_dependency 'addressable'
  s.add_dependency 'airbrake'
  s.add_dependency 'autoprefixer-rails'
  s.add_dependency 'bitly'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'bullet'
  s.add_dependency 'carrierwave'
  s.add_dependency 'ckeditor', '~> 4'
  s.add_dependency 'closure_tree'
  s.add_dependency 'combine_pdf'
  s.add_dependency 'daemons'
  s.add_dependency 'devise'
  s.add_dependency 'elasticsearch-dsl'
  s.add_dependency 'elasticsearch-model'
  s.add_dependency 'elasticsearch-persistence'
  s.add_dependency 'elasticsearch-rails'
  s.add_dependency 'fog-aws'
  s.add_dependency 'font-awesome-sass'
  s.add_dependency 'foundation-rails'
  s.add_dependency 'google-api-client'
  s.add_dependency 'heap'
  s.add_dependency 'hiredis'
  s.add_dependency 'httparty'
  s.add_dependency 'i18n-js'
  s.add_dependency 'jbuilder'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'js-routes'
  s.add_dependency 'lt-google-api', '~> 0.1'
  s.add_dependency 'lt-lcms', '~> 0.1'
  s.add_dependency 'migration_data'
  s.add_dependency 'mini_magick', '>= 4.9.4'
  s.add_dependency 'nested_form'
  s.add_dependency 'newrelic_rpm'
  s.add_dependency 'nikkou'
  s.add_dependency 'nokogiri', '>= 1.10.4'
  s.add_dependency 'oj'
  s.add_dependency 'oj_mimic_json'
  s.add_dependency 'pandoc-ruby'
  s.add_dependency 'pdfjs_viewer-rails'
  s.add_dependency 'pg'
  s.add_dependency 'pg_search'
  s.add_dependency 'rack-mini-profiler'
  s.add_dependency 'rails', '5.2.4.1'
  s.add_dependency 'rails-assets-classnames'
  s.add_dependency 'rails-assets-es6-promise'
  s.add_dependency 'rails-assets-eventemitter3'
  s.add_dependency 'rails-assets-fetch'
  s.add_dependency 'rails-assets-jstree'
  s.add_dependency 'rails-assets-knockout'
  s.add_dependency 'rails-assets-lodash'
  s.add_dependency 'rails-assets-selectize'
  s.add_dependency 'ransack'
  s.add_dependency 'react-rails', '~> 2.6.0'
  s.add_dependency 'readthis'
  s.add_dependency 'redis'
  s.add_dependency 'resque'
  s.add_dependency 'resque-scheduler'
  s.add_dependency 'rest-client'
  s.add_dependency 'ruby-progressbar'
  s.add_dependency 'rubyzip', '>= 1.3.0'
  s.add_dependency 'sanitize'
  s.add_dependency 'sass-rails'
  s.add_dependency 'simple_form'
  s.add_dependency 'staccato'
  s.add_dependency 'truncate_html'
  s.add_dependency 'turbolinks'
  s.add_dependency 'validate_url'
  s.add_dependency 'virtus'
  s.add_dependency 'will_paginate'
  s.add_dependency 'will_paginate-bootstrap'

  s.add_development_dependency 'capybara'
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
  s.add_development_dependency 'traceroute'
  s.add_development_dependency 'webdrivers', '~> 4.0'
end
