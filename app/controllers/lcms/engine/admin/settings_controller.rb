# frozen_string_literal: true

module Lcms
  module Engine
    module Admin
      class SettingsController < AdminController
        def toggle_editing_enabled
          Settings[:editing_enabled] = !Settings[:editing_enabled]
          notice = Settings[:editing_enabled] ? t('.enabled') : t('.disabled')
          redirect_to lcms_engine.admin_resources_path, notice: notice
        end
      end
    end
  end
end
