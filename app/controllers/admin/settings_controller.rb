# frozen_string_literal: true

module Admin
  class SettingsController < AdminController
    def toggle_editing_enabled
      Settings[:editing_enabled] = !Settings[:editing_enabled]
      notice = Settings[:editing_enabled] ? t('.enabled') : t('.disabled')
      redirect_to :admin_resources, notice: notice
    end
  end
end
