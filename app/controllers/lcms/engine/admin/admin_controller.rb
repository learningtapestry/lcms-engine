# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class AdminController < Lcms::Engine::ApplicationController
        include Lcms::Engine::PathHelper

        CONFIG_PATH ||= Rails.root.join('config', 'lcms-admin.yml')

        DEFAULTS ||= {
          layout: 'lcms/engine/admin',
        }.freeze

        RE_GOOGLE_FOLDER = %r{/drive/(.*/)?folders/}

        layout :customized_layout

        before_action :authenticate_admin!

        def self.settings
          @settings ||= DEFAULTS.merge((YAML.load_file(CONFIG_PATH) || {}).deep_symbolize_keys)
        end

        private

        def authenticate_admin!
          redirect_to dynamic_path(:root_path), alert: 'Access denied' unless current_user&.admin?
        end

        def customized_layout
          AdminController.settings[:layout] || DEFAULTS[:layout]
        end

        def customized_view
          @customized_view ||= AdminController
                                 .settings
                                 .dig(controller_name.to_sym, action_name.to_sym).presence
        end

        def render_customized_view
          render customized_view if customized_view
        end

        #
        # @see lcms-admin.yml
        # @return [Array<String>]
        #
        def view_links
          Array.wrap(AdminController.settings.dig(controller_name.to_sym, :view_links))
        end
      end
    end
  end
end
