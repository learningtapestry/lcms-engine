# frozen_string_literal: true

class CreateConformedDocumentsAlignments < Lcms::Engine::Migration
  def change
    create_table :conformed_documents_alignments do |t|
      t.references :conformed_document, references: :conformed_documents
      t.references :alignment, references: :alignments

      t.timestamps
    end
  end
end
