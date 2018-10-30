# frozen_string_literal: true

class RenameLearningResourceLocatorColumns < ActiveRecord::Migration[4.2]
  def change
    rename_column :lobject_urls, :learning_resource_locator_id, :url_id
  end
end
