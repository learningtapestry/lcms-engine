# frozen_string_literal: true

class AddFieldsToLessonDocument < Lcms::Engine::Migration
  def change
    enable_extension 'hstore'
    add_column :lesson_documents, :metadata, :hstore
    add_index :lesson_documents, :metadata, using: :gist
  end
end
