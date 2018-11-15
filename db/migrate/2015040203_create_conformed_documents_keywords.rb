# frozen_string_literal: true

class CreateConformedDocumentsKeywords < Lcms::Engine::Migration
  def change
    create_table :conformed_documents_keywords do |t|
      t.references :conformed_document, references: :conformed_documents
      t.references :keyword, references: :keywords

      t.timestamps
    end
  end
end
