# frozen_string_literal: true

class AddLinksToLessonDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :lesson_documents, :links, :hstore, default: ''
  end
end
