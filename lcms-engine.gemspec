# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'lcms/engine/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = 'lcms-engine'
  s.version = Lcms::Engine::VERSION
  s.authors = ['Rômulo Saksida', 'Abraham Sánchez']
  s.email = %w[rm@learningtapestry.com abraham@learningtapestry.com]
  s.homepage = 'https://github.com/learningtapestry/lcms-engine'
  s.summary = 'Rails engine for LCMS applications'
  s.description = 'Implements common components and features for Rails-based LCMS systems'
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '>= 2.3'

  s.add_dependency 'rails', '>= 4.2.10'

  s.add_development_dependency 'pg', '~> 1.1'

  s.add_development_dependency 'overcommit', '~> 0.46'
  s.add_development_dependency 'rspec-rails', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 0.59'
end
