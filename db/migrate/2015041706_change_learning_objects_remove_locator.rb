# frozen_string_literal: true

class ChangeLearningObjectsRemoveLocator < ActiveRecord::Migration[4.2]
  def change
    change_table :learning_objects do |t|
      t.remove :learning_resource_locator_id
    end
  end
end
