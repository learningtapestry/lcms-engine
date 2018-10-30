# frozen_string_literal: true

class RenameKeywords < ActiveRecord::Migration[4.2]
  def change
    rename_column :document_keywords, :keyword_id, :subject_id
    rename_column :lobject_keywords, :keyword_id, :subject_id

    rename_table :document_keywords, :document_subjects
    rename_table :lobject_keywords, :lobject_subjects
    rename_table :keywords, :subjects
  end
end
