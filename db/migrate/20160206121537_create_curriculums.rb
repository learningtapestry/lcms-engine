# frozen_string_literal: true

class CreateCurriculums < ActiveRecord::Migration[4.2]
  def change
    create_table :curriculums do |t|
      t.references :curriculum_type, index: true, foreign_key: true, null: false
      t.integer :parent_id, index: true
      t.integer :position
      t.integer :item_id, index: true, null: false
      t.string :item_type, index: true, null: false
    end

    add_foreign_key :curriculums, :curriculums, column: :parent_id
  end
end
