# frozen_string_literal: true

class AddPositionToDownloadCategory < Lcms::Engine::Migration
  def change
    add_column :download_categories, :position, :integer
    change_column :download_categories, :description, :text
    rename_column :download_categories, :name, :title
  end

  def data
    DownloadCategory.order(:id).each.with_index(1) do |category, index|
      params = {
        title: category.description,
        position: index
      }
      category.update_columns params
    end
  end
end
