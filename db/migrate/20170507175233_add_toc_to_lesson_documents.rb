# frozen_string_literal: true

class AddTocToLessonDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :lesson_documents, :toc, :jsonb
  end
end
