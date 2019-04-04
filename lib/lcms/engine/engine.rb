# frozen_string_literal: true

require 'active_job'
require 'acts-as-taggable-on'
require 'active_model_serializers'
require 'backport_new_renderer'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'closure_tree'
require 'devise'
require 'heap'
require 'i18n-js'
require 'jquery-rails'
require 'pdfjs_viewer-rails'
require 'ransack'
require 'react-rails'
require 'resque/server'
require 'turbolinks'
require 'validate_url'
require 'virtus'
require 'will_paginate'
require 'will_paginate-bootstrap'

# UI and asset specific gems have to be required for host app to have access to its assets
require 'ckeditor'
require 'font-awesome-sass'
require 'foundation-rails'
require 'js-routes'
require 'nested_form'
require 'rails-assets-classnames'
require 'rails-assets-es6-promise'
require 'rails-assets-eventemitter3'
require 'rails-assets-fetch'
require 'rails-assets-jstree'
require 'rails-assets-lodash'
require 'rails-assets-selectize'

# LearningTapestry gems
require 'lt/google/api'
require 'lt/google/api/auth/credentials'
require 'lt/lcms'

module Lcms
  module Engine
    # Top level engine class
    class Engine < ::Rails::Engine
      isolate_namespace Lcms::Engine

      config.redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'))

      config.autoload_paths += [
        config.root.join('lib'),
        config.root.join('app', 'jobs', 'concerns')
      ]

      config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.yml')]

      # Used by i18n-js gem
      config.middleware.use I18n::JS::Middleware

      config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload if ENV['ENABLE_LIVERELOAD']

      initializer('lcms.engine.react-rails') do |app|
        app.config.react.addons = true

        app.config.react.server_renderer_directories = ['lcms/engine/app/assets/javascripts']

        app.config.react.server_renderer_options = {
          files: ['lcms/engine/server_rendering.js'],
          replay_console: true
        }

        app.config.react.jsx_transform_options = {
          blacklist: %w(spec.functionName validation.react)
        }
      end

      config.assets.paths << "#{config.root}/public/javascripts"

      initializer 'lcms.engine.assets.precompile' do |app|
        app.config.assets.precompile += %w(
          admin.css
          application_lti.js
          ckeditor/*
          gdoc.css
          lcms_engine_manifest.js
          main.css
          pdf.css
          pdf_js_preview.js
          pdf_plain.css
          server_rendering.js
          vendor/pdf.worker.js
        )
      end

      initializer 'append_migrations' do |app|
        unless app.root.to_s.match?(root.to_s)
          config.paths['db/migrate'].expanded.each do |expanded_path|
            app.config.paths['db/migrate'] << expanded_path
          end
        end
      end

      config.after_initialize do
        config.active_job.queue_adapter = :resque

        if ::Rails.env.development? || ::Rails.env.test?
          require 'bullet'

          ::Bullet.enable = true
          ::Bullet.bullet_logger = true
          ::Bullet.console = true
          ::Bullet.rails_logger = true
        end
      end

      config.to_prepare do
        Dir
          .glob(Rails.root + 'app/decorators/**/*_decorator*.rb')
          .each(&method(:require_dependency))
      end

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_bot
        g.factory_bot dir: 'spec/factories'
      end

      ENABLE_CACHING = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(
        ENV.fetch('ENABLE_CACHING', true)
      )

      if ENABLE_CACHING
        redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
        config.cache_store = :readthis_store, {
          expires_in: 1.hour.to_i,
          namespace: 'unbounded',
          redis: { url: redis_url, driver: :hiredis }
        }
      else
        config.cache_store = :null_store
      end

      # NOTE: Sample to customize the layout
      # config.to_prepare do
      #   Devise::SessionsController.layout "layout_for_sessions_controller"
      # end
    end
  end
end
