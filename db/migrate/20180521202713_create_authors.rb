# frozen_string_literal: true

class CreateAuthors < ActiveRecord::Migration[4.2]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
