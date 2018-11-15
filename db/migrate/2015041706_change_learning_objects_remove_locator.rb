# frozen_string_literal: true

class ChangeLearningObjectsRemoveLocator < Lcms::Engine::Migration
  def change
    change_table :learning_objects do |t|
      t.remove :learning_resource_locator_id
    end
  end
end
