# frozen_string_literal: true

class CreateConformedDocumentIdentities < ActiveRecord::Migration[4.2]
  def change
    create_table :conformed_document_identities do |t|
      t.references :conformed_document, references: :conformed_documents
      t.references :identity, references: :identities
      t.integer :type

      t.timestamps
    end
  end
end
