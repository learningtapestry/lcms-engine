# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'lcms/engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'lcms-engine'
  s.version = Lcms::Engine::VERSION
  s.authors = ['Rômulo Saksida', 'Abraham Sánchez', 'Alexander Kuznetsov']
  s.email = %w(rm@learningtapestry.com abraham@learningtapestry.com alexander@learningtapestry.com)
  s.homepage = 'https://github.com/learningtapestry/lcms-engine'
  s.summary = 'Rails engine for LCMS applications'
  s.description = 'Implements common components and features for Rails-based LCMS systems'
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '>= 2.5'

  s.add_dependency 'rails', '>= 4.2.11'

  s.add_dependency 'acts-as-taggable-on', '~> 5.0'
  s.add_dependency 'carrierwave', '~> 1.0'
  s.add_dependency 'closure_tree', '~> 6.6'
  s.add_dependency 'google-api-client', '~> 0.9'
  s.add_dependency 'pg', '0.20'
  s.add_dependency 'pg_search', '~> 2.1'
  s.add_dependency 'resque', '~> 1.27'
  s.add_dependency 'resque-scheduler', '~> 4.3'
  s.add_dependency 'validate_url', '~> 1.0'
  s.add_dependency 'virtus', '~> 1.0.5'

  s.add_development_dependency 'bundler-audit', '~> 0.6.0'
  s.add_development_dependency 'overcommit', '~> 0.46'
  s.add_development_dependency 'rspec-rails', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.59.2'
end
