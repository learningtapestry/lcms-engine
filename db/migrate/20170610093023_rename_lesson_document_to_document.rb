# frozen_string_literal: true

class RenameLessonDocumentToDocument < ActiveRecord::Migration[4.2]
  def change
    rename_table :lesson_documents, :documents
  end
end
