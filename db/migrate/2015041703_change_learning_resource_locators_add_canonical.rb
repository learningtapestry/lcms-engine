# frozen_string_literal: true

class ChangeLearningResourceLocatorsAddCanonical < ActiveRecord::Migration[4.2]
  def change
    change_table :learning_resource_locators do |t|
      t.references :canonical, references: :learning_resource_locators
    end

    add_index :learning_resource_locators, :canonical_id
  end
end
