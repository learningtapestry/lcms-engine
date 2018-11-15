# frozen_string_literal: true

class ChangeSettingsToJson < Lcms::Engine::Migration
  def down
    add_column :settings, :created_at, :datetime
    add_column :settings, :editing_enabled, :boolean, default: true
    add_column :settings, :thumbnails_last_update, :datetime
    add_column :settings, :updated_at, :datetime

    if (settings = Settings.send :settings)
      settings.update editing_enabled: settings.data['editing_enabled']
      settings.update thumbnails_last_update: settings.data['thumbnails_last_update']
    end

    remove_column :settings, :data
  end

  def up
    add_column :settings, :data, :jsonb, default: '{}', null: false

    if (settings = Settings.send :settings)
      settings.update data: {
        editing_enabled: settings.editing_enabled?,
        thumbnails_last_update: settings.thumbnails_last_update
      }
    end

    remove_column :settings, :created_at
    remove_column :settings, :editing_enabled
    remove_column :settings, :thumbnails_last_update
    remove_column :settings, :updated_at
  end
end
