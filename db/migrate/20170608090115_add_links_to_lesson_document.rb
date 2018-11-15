# frozen_string_literal: true

class AddLinksToLessonDocument < Lcms::Engine::Migration
  def change
    add_column :lesson_documents, :links, :hstore, default: ''
  end
end
