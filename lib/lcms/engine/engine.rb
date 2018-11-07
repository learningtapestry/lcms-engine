# frozen_string_literal: true

require 'acts-as-taggable-on'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'closure_tree'
require 'resque/server'
require 'validate_url'
require 'virtus'

require 'lt/google/api'
require 'lt/lcms'

module Lcms
  module Engine
    # Top level engine class
    class Engine < ::Rails::Engine
      # TODO: Re-enable namespaces once engine extraction is more stable.
      # isolate_namespace Lcms::Engine

      config.to_prepare do
        Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
          require_dependency(c)
        end
      end
    end
  end
end
