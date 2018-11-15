# frozen_string_literal: true

class RenameLearningObjectLocators < Lcms::Engine::Migration
  def change
    rename_table :learning_object_locators, :learning_object_resource_locators
  end
end
