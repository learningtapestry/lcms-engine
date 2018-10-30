# frozen_string_literal: true

class CreateDownloads < ActiveRecord::Migration[4.2]
  def change
    create_table :downloads do |t|
      t.string :filename
      t.integer :filesize
      t.string :url
      t.string :content_type
      t.string :title
      t.string :description
      t.integer :parent_id, index: true
      t.timestamps null: false
    end

    create_table :document_downloads do |t|
      t.references :document, index: true, foreign_key: true
      t.references :download, index: true, foreign_key: true
      t.timestamps null: false
    end

    create_table :lobject_downloads do |t|
      t.references :lobject, index: true, foreign_key: true
      t.references :document, index: true, foreign_key: true
      t.references :download, index: true, foreign_key: true
      t.timestamps null: false
    end

    add_foreign_key :downloads, :downloads, column: :parent_id
  end
end
