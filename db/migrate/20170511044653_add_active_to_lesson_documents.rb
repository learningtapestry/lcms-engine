# frozen_string_literal: true

class AddActiveToLessonDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :lesson_documents, :active, :boolean, default: true, null: false
  end
end
