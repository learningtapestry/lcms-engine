# frozen_string_literal: true

class CreateLobjectChildren < Lcms::Engine::Migration
  def change
    create_table :lobject_children do |t|
      t.references :lobject, index: true, foreign_key: true
      t.references :child, index: true
      t.integer :position
      t.timestamps null: false
    end

    add_foreign_key :lobject_children, :lobjects, column: :child_id
  end
end
