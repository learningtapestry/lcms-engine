# frozen_string_literal: true

class AddUnitBundlesToDownloadCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :download_categories, :bundle, :boolean, null: false, default: false
  end
end
