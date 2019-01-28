# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in lcms-engine.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

gem 'lt-google-api',
    git: 'https://github.com/learningtapestry/lt-google-api.git',
    branch: 'refactoring'

gem 'lt-lcms',
    git: 'https://github.com/learningtapestry/lt-lcms.git',
    branch: 'refactoring'

gem 'wicked_pdf', git: 'https://github.com/learningtapestry/wicked_pdf.git',
                  branch: 'puppeteer-support', ref: '36b0e0e8'

source 'https://rails-assets.org' do
  gem 'rails-assets-classnames', '~> 2.2.3'
  gem 'rails-assets-es6-promise', '~> 3.1.2'
  gem 'rails-assets-eventemitter3', '~> 1.2.0'
  gem 'rails-assets-fetch', '~> 0.11.0'
  gem 'rails-assets-jstree', '~> 3.3.4'
  gem 'rails-assets-knockout', '~> 3.3.0'
  gem 'rails-assets-lodash', '~> 4.17.11'
  gem 'rails-assets-selectize', '~> 0.12.1'
end
