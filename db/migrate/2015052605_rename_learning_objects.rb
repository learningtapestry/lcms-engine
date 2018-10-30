# frozen_string_literal: true

class RenameLearningObjects < ActiveRecord::Migration[4.2]
  def change
    rename_table :learning_objects, :lobjects
    rename_table :learning_object_age_ranges, :lobject_age_ranges
    rename_table :learning_object_documents, :lobject_documents
    rename_table :learning_object_identities, :lobject_identities
    rename_table :learning_object_resource_locators, :lobject_resource_locators
    rename_table :learning_objects_alignments, :lobjects_alignments
    rename_table :learning_objects_keywords, :lobjects_keywords
  end
end
