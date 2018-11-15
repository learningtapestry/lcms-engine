# frozen_string_literal: true

class AddPdfToLessonDocuments < Lcms::Engine::Migration
  def change
    add_column :lesson_documents, :pdf, :string
  end
end
