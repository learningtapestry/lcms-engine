# frozen_string_literal: true

class CreateLobjectDescriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :lobject_descriptions do |t|
      t.string :description
      t.belongs_to :lobject
      t.timestamps
    end
  end
end
