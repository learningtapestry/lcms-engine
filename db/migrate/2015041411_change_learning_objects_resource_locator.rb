# frozen_string_literal: true

class ChangeLearningObjectsResourceLocator < ActiveRecord::Migration[4.2]
  def change
    change_table :learning_objects do |t|
      t.remove :resource_locator
      t.references :learning_resource_locator, references: :learning_resource_locators
    end
  end
end
