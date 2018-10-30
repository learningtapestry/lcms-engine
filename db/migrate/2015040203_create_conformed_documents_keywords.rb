# frozen_string_literal: true

class CreateConformedDocumentsKeywords < ActiveRecord::Migration[4.2]
  def change
    create_table :conformed_documents_keywords do |t|
      t.references :conformed_document, references: :conformed_documents
      t.references :keyword, references: :keywords

      t.timestamps
    end
  end
end
