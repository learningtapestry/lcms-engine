# frozen_string_literal: true

class CreateLobjectAdditionalLobjects < ActiveRecord::Migration[4.2]
  def change
    create_table :lobject_additional_lobjects do |t|
      t.references :lobject, foreign_key: true, null: false
      t.references :additional_lobject, index: true, null: false
      t.integer :position
      t.timestamps null: false

      t.index %i(lobject_id additional_lobject_id), name: 'index_lobject_additional_lobjects', unique: true

      t.foreign_key :lobjects, column: :additional_lobject_id
    end
  end
end
