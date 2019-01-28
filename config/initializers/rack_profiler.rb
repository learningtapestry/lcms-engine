# frozen_string_literal: true

if Rails.env == 'development' && ENV.fetch('DISABLE_PROFILER', 0).to_i.zero?
  require 'rack-mini-profiler'

  # Fix circular ref conflict with Oj.mimic_json
  module Rack
    class MiniProfiler
      module TimerStruct
        class Base
          def as_json
            @attributes
          end
        end
      end
    end
  end

  # initialization is skipped so trigger it
  Rack::MiniProfiler.config.position = 'right'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
