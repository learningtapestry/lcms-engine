# frozen_string_literal: true

class RenameLearningObjectLocators < ActiveRecord::Migration[4.2]
  def change
    rename_table :learning_object_locators, :learning_object_resource_locators
  end
end
