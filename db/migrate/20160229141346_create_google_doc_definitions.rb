# frozen_string_literal: true

class CreateGoogleDocDefinitions < ActiveRecord::Migration[4.2]
  def change
    create_table :google_doc_definitions do |t|
      t.string :keyword, null: false
      t.string :description, null: false

      t.timestamps null: false

      t.index :keyword, unique: true
    end
  end
end
