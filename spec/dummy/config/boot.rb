# frozen_string_literal: true

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __dir__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
$LOAD_PATH.unshift File.expand_path('../../../lib', __dir__)

require 'dotenv'
prefix = File.expand_path '../', __dir__
Dotenv.load(
  File.join(prefix, ".env.#{ENV['RAILS_ENV'] || :development}"),
  File.join(prefix, '.env')
)
