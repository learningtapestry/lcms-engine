# frozen_string_literal: true

class CreateLobjectCollectionTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :lobject_collection_types do |t|
      t.string :name, null: false
      t.timestamps null: false

      t.index :name, unique: true
    end
  end
end
