# frozen_string_literal: true

class CreateLessonDocuments < Lcms::Engine::Migration
  def change
    create_table :lesson_documents do |t|
      t.string :file_id, index: true
      t.string :name
      t.datetime :last_modified_at
      t.string :last_author_email
      t.string :last_author_name
      t.text :original_content
      t.string :version

      t.timestamps null: false
    end
  end
end
