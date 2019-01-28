# frozen_string_literal: true

Resque.redis = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
Resque.redis.namespace = ENV.fetch('RESQUE_NAMESPACE', 'resque:development')

project_id = ENV['AIR_BRAKE_PROJECT_ID']
project_key = ENV['AIR_BRAKE_PROJECT_KEY']

if project_id.present? && project_key.present?
  require 'airbrake/resque'
  Resque::Failure.backend = Resque::Failure::Airbrake
end
