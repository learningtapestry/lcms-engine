# frozen_string_literal: true

class CreateCurriculumHierarchies < ActiveRecord::Migration[4.2]
  def change
    create_table :curriculum_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :curriculum_hierarchies, %i(ancestor_id descendant_id generations),
              unique: true,
              name: 'curriculum_anc_desc_idx'

    add_index :curriculum_hierarchies, [:descendant_id],
              name: 'curriculum_desc_idx'
  end
end
