# frozen_string_literal: true

class AddLongDescriptionToDownloadCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :download_categories, :long_description, :text
  end
end
