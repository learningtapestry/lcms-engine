# frozen_string_literal: true

class CreateLobjectCollections < Lcms::Engine::Migration
  def change
    create_table :lobject_collections do |t|
      t.references :lobject, index: true, foreign_key: true
      t.timestamps null: false
    end

    change_table :lobject_children do |t|
      t.references :lobject_collection, index: true, foreign_key: true
      t.rename :lobject_id, :parent_id
    end
  end
end
