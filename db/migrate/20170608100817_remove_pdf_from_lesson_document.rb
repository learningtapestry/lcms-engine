# frozen_string_literal: true

class RemovePdfFromLessonDocument < Lcms::Engine::Migration
  def change
    remove_column :lesson_documents, :pdf
  end
end
