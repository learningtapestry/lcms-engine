# frozen_string_literal: true

class AddPdfToLessonDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :lesson_documents, :pdf, :string
  end
end
