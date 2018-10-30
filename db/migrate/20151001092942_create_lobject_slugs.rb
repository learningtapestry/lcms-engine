# frozen_string_literal: true

class CreateLobjectSlugs < ActiveRecord::Migration[4.2]
  def change
    create_table :lobject_slugs do |t|
      t.references :lobject, foreign_key: true, null: false
      t.references :lobject_collection, foreign_key: true, index: true
      t.string :value, null: false
      t.timestamps null: false

      t.index %i(lobject_id lobject_collection_id), unique: true
      t.index :value, unique: true
    end
  end
end
