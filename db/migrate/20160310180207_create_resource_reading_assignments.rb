# frozen_string_literal: true

class CreateResourceReadingAssignments < ActiveRecord::Migration[4.2]
  def change
    create_table :resource_reading_assignments do |t|
      t.references :resource, index: true, foreign_key: true, null: false
      t.string :title, null: false
      t.string :text_type, null: false
      t.string :author, null: false
    end
  end
end
