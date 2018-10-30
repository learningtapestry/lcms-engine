# frozen_string_literal: true

require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'acts-as-taggable-on'
require 'closure_tree'
require 'validate_url'

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
