# frozen_string_literal: true

class AddActiveToLessonDocuments < Lcms::Engine::Migration
  def change
    add_column :lesson_documents, :active, :boolean, default: true, null: false
  end
end
