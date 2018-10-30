# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[4.2]
  def change
    create_table :pages do |t|
      t.text :body, null: false
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end
