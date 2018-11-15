# frozen_string_literal: true

class AddTocToLessonDocuments < Lcms::Engine::Migration
  def change
    add_column :lesson_documents, :toc, :jsonb
  end
end
