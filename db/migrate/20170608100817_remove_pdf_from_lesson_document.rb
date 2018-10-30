# frozen_string_literal: true

class RemovePdfFromLessonDocument < ActiveRecord::Migration[4.2]
  def change
    remove_column :lesson_documents, :pdf
  end
end
