# frozen_string_literal: true

class DropCollectionTables < ActiveRecord::Migration[4.2]
  def change
    drop_table :resource_children
    drop_table :resource_collections
    drop_table :resource_collection_types
  end
end
