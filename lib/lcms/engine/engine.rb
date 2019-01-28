# frozen_string_literal: true

require 'acts-as-taggable-on'
require 'bullet' if ::Rails.env.development?
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'closure_tree'
require 'devise'
require 'heap'
require 'i18n-js'
require 'pdfjs_viewer-rails'
require 'react-rails'
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

      config.redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379'))

      config.autoload_paths += [
        config.root.join('lib'),
        config.root.join('app', 'jobs', 'concerns')
      ]

      config.i18n.load_path += Dir[config.root.join('config', 'locales', '**', '*.yml')]

      config.active_job.queue_adapter = :resque

      # Used by i18n-js gem
      config.middleware.use I18n::JS::Middleware

      config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload if ENV['ENABLE_LIVERELOAD']

      config.react.server_renderer_directories = ['lcms/engine/app/assets/javascripts']

      # Fixes server rendering in production.
      # Ref. https://github.com/reactjs/react-rails/issues/443#issuecomment-180544359
      config.react.server_renderer_options = {
        files: ['lcms/engine/server_rendering.js']
      }

      config.react.jsx_transform_options = {
        blacklist: %w(spec.functionName validation.react)
      }

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

      config.after_initialize do
        ::Bullet.enable = true
        ::Bullet.bullet_logger = true
        ::Bullet.console = true
        ::Bullet.rails_logger = true
      end

      # NOTE: Sample to customize the layout
      # config.to_prepare do
      #   Devise::SessionsController.layout "layout_for_sessions_controller"
      # end
    end
  end
end
