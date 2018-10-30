# frozen_string_literal: true

class CreateGrades < ActiveRecord::Migration[4.2]
  def change
    create_table :grades do |t|
      t.string :grade
      t.integer :parent_id, index: true
      t.timestamps null: false
    end

    create_table :document_grades do |t|
      t.references :document, index: true, foreign_key: true
      t.references :grade, index: true, foreign_key: true
      t.timestamps null: false
    end

    create_table :lobject_grades do |t|
      t.references :lobject, index: true, foreign_key: true
      t.references :document, index: true, foreign_key: true
      t.references :grade, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_foreign_key :grades, :grades, column: :parent_id
  end
end
