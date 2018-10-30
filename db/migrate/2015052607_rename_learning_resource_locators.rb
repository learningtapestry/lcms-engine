# frozen_string_literal: true

class RenameLearningResourceLocators < ActiveRecord::Migration[4.2]
  def change
    rename_table :learning_resource_locators, :urls
    rename_table :lobject_resource_locators, :lobject_urls
  end
end
