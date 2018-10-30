# frozen_string_literal: true

class CreateLearningResourceLocatorSynonyms < ActiveRecord::Migration[4.2]
  def change
    create_table :learning_resource_locator_synonyms do |t|
      t.references :learning_resource_locator, references: :learning_resource_locators
      t.string :synonym
      t.timestamps
    end
  end
end
