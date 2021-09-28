# frozen_string_literal: true

if Rails.env == 'development' && ENV.fetch('DISABLE_PROFILER', 0).to_i.zero?
  require 'rack-mini-profiler'

  # initialization is skipped so trigger it
  Rack::MiniProfiler.config.position = 'right'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
