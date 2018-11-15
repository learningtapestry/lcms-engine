# frozen_string_literal: true

class AddCollectionConstraints < Lcms::Engine::Migration
  def up
    change_column :lobject_collections, :lobject_id, :integer, null: false

    change_column :lobject_children, :child_id, :integer, null: false
    change_column :lobject_children, :lobject_collection_id, :integer, null: false
    change_column :lobject_children, :parent_id, :integer, null: false
    change_column :lobject_children, :position, :integer, null: false

    add_index :lobject_children, %i(lobject_collection_id child_id), unique: true

    remove_index :lobject_children, :lobject_collection_id
  end

  def down
    change_column :lobject_collections, :lobject_id, :integer, null: true

    change_column :lobject_children, :child_id, :integer, null: true
    change_column :lobject_children, :lobject_collection_id, :integer, null: true
    change_column :lobject_children, :parent_id, :integer, null: true
    change_column :lobject_children, :position, :integer, null: true

    remove_index :lobject_children, %i(lobject_collection_id child_id)

    add_index :lobject_children, :lobject_collection_id
  end
end
