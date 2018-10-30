# frozen_string_literal: true

class CreateResourceHierarchies < ActiveRecord::Migration[4.2]
  def change
    create_table :resource_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :resource_hierarchies, %i(ancestor_id descendant_id generations),
              unique: true,
              name: 'resource_anc_desc_idx'

    add_index :resource_hierarchies, [:descendant_id],
              name: 'resource_desc_idx'
  end
end
