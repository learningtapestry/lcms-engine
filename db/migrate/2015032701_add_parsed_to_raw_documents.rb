# frozen_string_literal: true

class AddParsedToRawDocuments < Lcms::Engine::Migration
  def change
    change_table :raw_documents do |t|
      t.boolean :parsed, null: false, default: false
      add_index :raw_documents, :parsed
    end
  end
end
