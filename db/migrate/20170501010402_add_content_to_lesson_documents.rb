# frozen_string_literal: true

class AddContentToLessonDocuments < Lcms::Engine::Migration
  def change
    add_column :lesson_documents, :content, :text
  end
end
