# frozen_string_literal: true

class CreateGoogleDocs < ActiveRecord::Migration[4.2]
  def change
    create_table :google_docs do |t|
      t.string :content, null: false
      t.string :file_id, null: false
      t.string :name, null: false
      t.string :original_content, null: false

      t.timestamps null: false

      t.index :file_id, unique: true
    end
  end
end
