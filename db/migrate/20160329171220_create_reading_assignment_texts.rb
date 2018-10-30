# frozen_string_literal: true

class CreateReadingAssignmentTexts < ActiveRecord::Migration[4.2]
  def change
    create_table :reading_assignment_texts do |t|
      t.string :name, index: true, null: false
      t.references :reading_assignment_author, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
