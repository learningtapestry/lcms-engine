# frozen_string_literal: true

class AddActivitiesMetadataToLessonDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :lesson_documents, :activity_metadata, :jsonb
  end
end
