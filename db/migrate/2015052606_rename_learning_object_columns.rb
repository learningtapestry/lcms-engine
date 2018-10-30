# frozen_string_literal: true

class RenameLearningObjectColumns < ActiveRecord::Migration[4.2]
  def change
    rename_column :lobject_age_ranges, :learning_object_id, :lobject_id
    rename_column :lobject_documents, :learning_object_id, :lobject_id
    rename_column :lobject_identities, :learning_object_id, :lobject_id
    rename_column :lobject_resource_locators, :learning_object_id, :lobject_id
    rename_column :lobjects_alignments, :learning_object_id, :lobject_id
    rename_column :lobjects_keywords, :learning_object_id, :lobject_id
  end
end
