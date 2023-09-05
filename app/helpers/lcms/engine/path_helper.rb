# frozen_string_literal: true

module Lcms
  module Engine
    module PathHelper
      include Rails.application.routes.url_helpers

      def dynamic_path(path, *)
        host_engine_path(path, *).presence || main_app.send(path.to_sym, *)
      end

      def dynamic_document_path(*)
        host_engine_path(:document_path, *).presence || main_app.document_path(*)
      end

      def dynamic_material_path(*)
        host_engine_path(:material_path, *).presence || main_app.material_path(*)
      end

      private

      def host_engine_path(key, *)
        settings = Lcms::Engine::Admin::AdminController.settings
        if (host_route = settings.dig(:redirect, :host, key)).present?
          main_app.send(host_route.to_sym, *)
        elsif (engine_route = settings.dig(:redirect, :engine, key)).present?
          lcms_engine.send(engine_route.to_sym, *)
        else
          raise "Please tune up config/lcms-admin.yml and set redirect:host:#{key} or redirect:engine:#{key} values"
        end
      end
    end
  end
end
