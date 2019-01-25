# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      module ConfigurableAdmin
        def engine_klass
          @engine_klass ||= settings[:engine].constantize
        end

        def document_path(*args)
          @document_path ||= host_engine_path(:document_path, args) || super
        end

        def material_path(*args)
          @material_path ||= host_engine_path(:material_path, args) || super
        end

        def root_path
          @root_path ||= host_engine_path(:root_path) || explore_curriculum_index_path
        end

        def host_engine_path(key, *args)
          if (host_route = settings&.[](:redirect)&.[](:host)&.[](key)).present?
            Rails.application.routes.url_helpers.send(host_route, args)
          elsif (engine_route = settings&.[](:redirect)&.[](:engine)&.[](key)).present?
            engine_klass.routes.url_helpers.send(engine_route, args)
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
          settings[:layout] || 'admin'
        end

        def render_customized_view
          custom_view = settings&.[](controller_name.to_sym)&.[](action_name.to_sym).presence
          render custom_view if custom_view.present?
        end

        def view_links
          Array.wrap(settings[controller_name.to_sym]&.dig(:view_links))
        end
      end
    end
  end
end
