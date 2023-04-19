# frozen_string_literal: true

require 'active_job'
require 'acts-as-taggable-on'
require 'active_model_serializers'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'closure_tree'
require 'devise'
require 'pdfjs_viewer-rails'
require 'ransack'
require 'resque/server'
require 'validate_url'
require 'virtus'
require 'will_paginate'

# UI and asset specific gems have to be required for host app to have access to its assets
require 'ckeditor'
require 'font-awesome-sass'
require 'js-routes'
require 'nested_form'

# LearningTapestry gems
require 'lt/google/api'
require 'lt/google/api/auth/credentials'
require 'lt/lcms'

module Lcms
  module Engine
    class Engine < ::Rails::Engine
      isolate_namespace Lcms::Engine

      config.redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'))

      config.autoload_paths += [
        config.root.join('lib'),
        config.root.join('app', 'jobs', 'concerns')
      ]

      config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.yml')]

      config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload if ENV['ENABLE_LIVERELOAD']

      config.assets.paths << config.root.join("node_modules/bootstrap-icons/font")

      config.after_initialize do
        config.active_job.queue_adapter = :resque

        # TODO: Check if can move bullet to the DEV environment only
        # if ::Rails.env.development? || ::Rails.env.test?
        #   require 'bullet'
        #
        #   ::Bullet.enable = true
        #   ::Bullet.bullet_logger = true
        #   ::Bullet.console = true
        #   ::Bullet.rails_logger = true
        # end
      end

      config.to_prepare do
        # Check if the DB exists
        next unless ActiveRecord::Base.connection

        # Possible decorators
        decorators = %W[
          #{Rails.root}/app/decorators/**/*_decorator*.rb
          #{Rails.root}/app/**/lcms/engine/*_decorator*.rb
        ]

        Dir.glob(decorators).each(&method(:require))
      rescue ActiveRecord::NoDatabaseError
        puts 'ActiveRecord::NoDatabaseError thrown!'
      end

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot
        g.factory_bot dir: 'spec/factories'
      end

      initializer 'append_migrations' do |app|
        unless app.root.to_s.match?(root.to_s)
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end

      initializer 'lcms.engine.assets.precompile' do |app|
        app.config.assets.precompile += %w(lcms_engine_manifest.js ckeditor/config.js)
      end

      # Serves the engine's built assets when requested
      initializer 'lcms_engine.assets.static' do |app|
        app.config.middleware.use(
          Rack::Static,
          urls: ['/lcms-engine-assets'],
          root: File.join(Gem.loaded_specs['lcms-engine'].full_gem_path, 'public')
        )
      end

      initializer 'lcms_eninge.middleware' do |app|
        # Setup js-routes middleware
        app.config.middleware.use(JsRoutes::Middleware)
      end

      # NOTE: Sample to customize the layout
      # config.to_prepare do
      #   Devise::SessionsController.layout "layout_for_sessions_controller"
      # end
    end
  end
end
