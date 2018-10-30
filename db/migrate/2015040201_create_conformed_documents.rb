# frozen_string_literal: true

class CreateConformedDocuments < ActiveRecord::Migration[4.2]
  def change
    create_table :conformed_documents do |t|
      t.string  :doc_id
      t.integer :doc_schema_format
      t.timestamp :doc_created_at
      t.string  :description
      t.string  :title
      t.string  :resource_locator

      t.timestamps
    end

    add_index :conformed_documents, :doc_id, unique: true
    add_index :conformed_documents, :resource_locator
  end
end
