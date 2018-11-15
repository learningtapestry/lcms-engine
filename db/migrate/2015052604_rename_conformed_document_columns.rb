# frozen_string_literal: true

class RenameConformedDocumentColumns < Lcms::Engine::Migration
  def change
    rename_column :document_age_ranges, :conformed_document_id, :document_id
    rename_column :document_identities, :conformed_document_id, :document_id
    rename_column :documents_alignments, :conformed_document_id, :document_id
    rename_column :documents_keywords, :conformed_document_id, :document_id
    rename_column :learning_object_documents, :conformed_document_id, :document_id
  end
end
