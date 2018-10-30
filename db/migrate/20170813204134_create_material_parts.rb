# frozen_string_literal: true

class CreateMaterialParts < ActiveRecord::Migration[4.2]
  def change
    create_table :material_parts do |t|
      t.references :material, index: true, foreign_key: true
      t.text :content
      t.integer :context_type, default: 0
      t.string :part_type
      t.boolean :active

      t.timestamps null: false
    end
  end
end
