# frozen_string_literal: true

class RenameDocumentJoinTables < Lcms::Engine::Migration
  def change
    rename_table :documents_alignments, :document_alignments
    rename_table :documents_keywords, :document_keywords
    rename_table :documents_languages, :document_languages
    rename_table :documents_resource_types, :document_resource_types
  end
end
