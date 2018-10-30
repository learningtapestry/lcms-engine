# frozen_string_literal: true

class AddFoundationalMetadataToLessonDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :lesson_documents, :foundational_metadata, :hstore
  end
end
