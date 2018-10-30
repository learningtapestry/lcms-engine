# frozen_string_literal: true

class AddSettingsToResource < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :download_categories_settings, :jsonb, default: {}, null: false
  end
end
