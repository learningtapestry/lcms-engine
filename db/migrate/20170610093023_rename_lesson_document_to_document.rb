# frozen_string_literal: true

class RenameLessonDocumentToDocument < Lcms::Engine::Migration
  def change
    rename_table :lesson_documents, :documents
  end
end
