# frozen_string_literal: true

class DeleteLearningResourceLocatorSynonyms < Lcms::Engine::Migration
  def change
    drop_table :learning_resource_locator_synonyms
  end
end
