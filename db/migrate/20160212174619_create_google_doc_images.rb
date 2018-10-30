# frozen_string_literal: true

class CreateGoogleDocImages < ActiveRecord::Migration[4.2]
  def change
    create_table :google_doc_images do |t|
      t.string :file, null: false
      t.string :original_url, null: false

      t.timestamps null: false

      t.index :original_url, unique: true
    end
  end
end
