# frozen_string_literal: true

class DropPages < ActiveRecord::Migration[5.2]
  def change
    drop_table :pages do |t|
      t.text :body, null: false
      t.string :slug, null: false
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end
