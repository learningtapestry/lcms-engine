# frozen_string_literal: true

class CreateConformedDocumentsAlignments < ActiveRecord::Migration[4.2]
  def change
    create_table :conformed_documents_alignments do |t|
      t.references :conformed_document, references: :conformed_documents
      t.references :alignment, references: :alignments

      t.timestamps
    end
  end
end
