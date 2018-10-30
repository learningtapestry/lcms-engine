# frozen_string_literal: true

class AddParsedToRawDocuments < ActiveRecord::Migration[4.2]
  def change
    change_table :raw_documents do |t|
      t.boolean :parsed, null: false, default: false
      add_index :raw_documents, :parsed
    end
  end
end
