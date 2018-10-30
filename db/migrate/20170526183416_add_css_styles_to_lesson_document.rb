# frozen_string_literal: true

class AddCssStylesToLessonDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :lesson_documents, :css_styles, :text
  end
end
