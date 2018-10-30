# frozen_string_literal: true

class CreateLobjectRelatedLobjects < ActiveRecord::Migration[4.2]
  def change
    create_table :lobject_related_lobjects do |t|
      t.references :lobject, index: true, foreign_key: true
      t.references :related_lobject, index: true
      t.integer :position
      t.timestamps null: false
    end

    add_foreign_key :lobject_related_lobjects, :lobjects, column: :related_lobject_id
  end
end
