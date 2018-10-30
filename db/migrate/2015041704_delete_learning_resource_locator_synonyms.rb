# frozen_string_literal: true

class DeleteLearningResourceLocatorSynonyms < ActiveRecord::Migration[4.2]
  def change
    drop_table :learning_resource_locator_synonyms
  end
end
