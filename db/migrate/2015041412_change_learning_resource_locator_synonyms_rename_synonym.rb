# frozen_string_literal: true

class ChangeLearningResourceLocatorSynonymsRenameSynonym < ActiveRecord::Migration[4.2]
  def change
    change_table :learning_resource_locator_synonyms do |t|
      t.rename :synonym, :url
    end
  end
end
