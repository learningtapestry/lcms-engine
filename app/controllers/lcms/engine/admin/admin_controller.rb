# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class AdminController < Lcms::Engine::ApplicationController
        CONFIG_PATH ||= Rails.root.join('config', 'lcms-admin.yml')

        DEFAULTS ||= {
          layout: 'admin',
          materials_query: AdminMaterialsQuery
        }.freeze

        layout :customized_layout

        before_action :authenticate_admin!

        class << self
          def settings
            @settings ||= DEFAULTS.merge((YAML.load_file(CONFIG_PATH) || {}).deep_symbolize_keys)
          end

          def engine_klass
            @engine_klass ||= settings[:engine]&.constantize
          end

          def document_path(*args)
            host_engine_path(:document_path, args).presence || url_helpers.document_path(args)
          end

          def material_path(*args)
            host_engine_path(:material_path, args).presence || url_helpers.material_path(args)
          end

          def root_path
            host_engine_path(:root_path).presence || url_helpers.root_path
          end

          def host_engine_path(key, *args)
            if (host_route = settings.dig(:redirect, :host, key)).present?
              Rails.application.routes.url_helpers.send(host_route, args)
            elsif (engine_route = settings.dig(:redirect, :engine, key)).present?
              engine_klass.routes.url_helpers.send(engine_route, args)
            end
          end

          private

          def url_helpers
            Rails.application.routes.url_helpers
          end
        end

        def whoami
          render text: "stack=#{ENV['CLOUD66_STACK_NAME']}<br/>env=#{ENV['CLOUD66_STACK_ENVIRONMENT']}"
        end

        private

        def authenticate_admin!
          redirect_to root_path, alert: 'Access denied' unless current_user&.admin?
        end

        def customized_layout
          AdminController.settings[:layout] || 'admin'
        end

        def customized_view
          @customized_view ||= AdminController
                                 .settings
                                 .dig(controller_name.to_sym, action_name.to_sym).presence
        end

        def render_customized_view
          render customized_view if customized_view
        end

        def view_links
          Array.wrap(AdminController.settings.dig(controller_name.to_sym, :view_links))
        end
      end
    end
  end
end
