# frozen_string_literal: true

require 'acts-as-taggable-on'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'closure_tree'
require 'devise'
require 'resque/server'
require 'validate_url'
require 'virtus'

require 'lt/google/api'
require 'lt/google/api/auth/credentials'
require 'lt/lcms'

module Lcms
  module Engine
    # Top level engine class
    class Engine < ::Rails::Engine
      isolate_namespace Lcms::Engine

      config.autoload_paths += [
        config.root.join('lib'),
        config.root.join('app', 'jobs', 'concerns')
      ]

      config.assets.precompile += %w(*.svg *.ico)

      initializer 'lcms.engine.assets.precompile' do |app|
        app.config.assets.precompile += %w(lcms_engine_manifest.js)
      end

      # NOTE: Sample to customize the layout
      # config.to_prepare do
      #   Devise::SessionsController.layout "layout_for_sessions_controller"
      # end
    end
  end
end
