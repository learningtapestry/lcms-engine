# frozen_string_literal: true

class AddDescriptionToResourceDownload < ActiveRecord::Migration[4.2]
  def change
    add_column :resource_downloads, :description, :text
  end
end
