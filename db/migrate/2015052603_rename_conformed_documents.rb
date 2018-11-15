# frozen_string_literal: true

class RenameConformedDocuments < Lcms::Engine::Migration
  def change
    rename_table :conformed_documents, :documents
    rename_table :conformed_document_age_ranges, :document_age_ranges
    rename_table :conformed_document_identities, :document_identities
    rename_table :conformed_documents_alignments, :documents_alignments
    rename_table :conformed_documents_keywords, :documents_keywords
    rename_table :learning_object_conformed_documents, :learning_object_documents
  end
end
