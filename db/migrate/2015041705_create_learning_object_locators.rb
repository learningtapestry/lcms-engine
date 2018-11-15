# frozen_string_literal: true

class CreateLearningObjectLocators < Lcms::Engine::Migration
  def change
    create_table :learning_object_locators do |t|
      t.references :learning_object, references: :learning_objects
      t.references :learning_resource_locator, references: :learning_resource_locators
      t.timestamps
    end
  end
end
