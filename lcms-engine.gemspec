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

  s.files = Dir['{app,bin,config,db,docs,lib,public,sig,templates, vendor}/**/*', 'LICENSE', 'README.md',
                'lcms-engine.gemspec', 'Gemfile', 'Gemfile.lock']

  # 3.5 should add frozen string literal, and it's
  # better to double-check the compatibility before upgrading to 3.5
  s.required_ruby_version = '~> 3.2', '< 3.5'

  s.add_dependency 'activejob-retry', '~> 0.6.3'
  s.add_dependency 'active_model_serializers', '~> 0.10.10'
  s.add_dependency 'acts_as_list', '~> 1.0'
  s.add_dependency 'acts-as-taggable-on', '~> 12.0'
  s.add_dependency 'airbrake', '~> 13.0'
  s.add_dependency 'autoprefixer-rails', '~> 10.0'
  s.add_dependency 'aws-sdk-rails', '~> 4.0'
  s.add_dependency 'aws-sdk-s3', '~> 1'
  s.add_dependency 'carrierwave', '~> 3.0'
  s.add_dependency 'ckeditor', '~> 5.1', '>= 5.1.3'
  s.add_dependency 'closure_tree', '~> 7.1'
  s.add_dependency 'combine_pdf', '~> 1.0'
  s.add_dependency 'concurrent-ruby', '~> 1.3'
  s.add_dependency 'cssbundling-rails', '~> 1.4'
  s.add_dependency 'devise', '~> 4.9'
  s.add_dependency 'elasticsearch-dsl', '~> 0.1.9'
  s.add_dependency 'elasticsearch-model', '~> 8.0'
  s.add_dependency 'elasticsearch-persistence', '~> 8.0'
  s.add_dependency 'elasticsearch-rails', '~> 8.0'
  s.add_dependency 'fog-aws', '~> 3.5', '>= 3.5.2'
  s.add_dependency 'google-apis-drive_v3', '~> 0.66'
  s.add_dependency 'google-apis-script_v1', '~> 0.28'
  s.add_dependency 'hiredis', '~> 0.6.3'
  s.add_dependency 'httparty', '~> 0.22'
  s.add_dependency 'jbuilder', '~> 2.12'
  s.add_dependency 'lt-google-api', '~> 0.4'
  s.add_dependency 'lt-lcms', '~> 0.7'
  s.add_dependency 'mini_magick', '~> 4.12'
  s.add_dependency 'nokogiri', '~> 1.16'
  s.add_dependency 'oj', '~> 3.16'
  s.add_dependency 'oj_mimic_json', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'pg', '~> 1.5'
  s.add_dependency 'pg_search', '~> 2.3', '>= 2.3.2'
  s.add_dependency 'rack', '~> 3.0'
  s.add_dependency 'rack-mini-profiler', '~> 4.0'
  s.add_dependency 'rails', '~> 8.0.0'
  s.add_dependency 'ransack', '~> 4.2'
  s.add_dependency 'redis', '~> 5.4'
  s.add_dependency 'resque', '~> 2.6'
  s.add_dependency 'resque-scheduler', '~> 4.10'
  s.add_dependency 'rest-client', '~> 2.1', '>= 2.1.0'
  s.add_dependency 'retriable', '~> 3.1'
  s.add_dependency 'ruby-progressbar', '~> 1.13'
  s.add_dependency 'rubyzip', '~> 2.3'
  s.add_dependency 'sanitize', '~> 6.1'
  s.add_dependency 'sass-rails', '~> 6.0'
  s.add_dependency 'simple_form', '~> 5.3'
  s.add_dependency 'sprockets-rails', '~> 3.5'
  s.add_dependency 'validate_url', '~> 1.0', '>= 1.0.8'
  s.add_dependency 'virtus', '~> 1.0', '>= 1.0.5'
  s.add_dependency 'will_paginate', '~> 4.0'
  s.add_dependency 'will_paginate-bootstrap-style', '~> 0.3'
  s.add_dependency 'with_advisory_lock', '~> 5.0'

  s.add_development_dependency 'bullet', '~> 8.0'
  s.add_development_dependency 'capybara', '~> 3.40'
  s.add_development_dependency 'database_cleaner-active_record', '~> 2.2'
  s.add_development_dependency 'dotenv-rails', '~> 3.0'
  s.add_development_dependency 'email_spec', '~> 2.2'
  s.add_development_dependency 'factory_bot', '~> 6.5'
  s.add_development_dependency 'faker', '~> 3.4'
  s.add_development_dependency 'jsbundling-rails', '~> 1.3'
  s.add_development_dependency 'mock_redis', '~> 0.51'
  s.add_development_dependency 'overcommit', '~> 0.68'
  s.add_development_dependency 'rbs_rails', '~> 0.12'
  s.add_development_dependency 'rspec-rails', '~> 7.1'
  s.add_development_dependency 'rubocop', '~> 1.79'
  s.add_development_dependency 'sdoc', '~> 2.6'
  s.add_development_dependency 'seedbank', '~> 0.5'
  s.add_development_dependency 'selenium-webdriver', '~> 4.27'
  s.add_development_dependency 'shoulda-matchers', '~> 6.5'
  s.add_development_dependency 'simplecov', '~> 0.22'
  s.add_development_dependency 'spring', '~> 4.2'
  s.add_development_dependency 'spring-commands-rspec', '~> 1.0'
  s.add_development_dependency 'steep', '~> 1.10.0'
  s.add_development_dependency 'traceroute', '~> 0.8'
  s.add_development_dependency 'webdrivers', '~> 5.0'
end
