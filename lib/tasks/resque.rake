# frozen_string_literal: true

require 'resque/tasks'

namespace :resque do
  task setup: :environment do
    ENV['QUEUE'] ||= 'default'

    # Solution for the "prepared statements" on ActiveJob issue:
    #   Error while trying to deserialize arguments: PG::DuplicatePstatement: ERROR: prepared
    #   statement "a1" already exists
    #
    # Some references on this here:
    # https://github.com/rails/rails/pull/17607
    # https://github.com/rails/rails/pull/25827
    Resque.before_fork do
      ActiveRecord::Base.establish_connection
    end
  end
end
