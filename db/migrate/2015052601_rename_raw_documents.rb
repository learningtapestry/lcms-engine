# frozen_string_literal: true

class RenameRawDocuments < Lcms::Engine::Migration
  def change
    rename_table :raw_documents, :lr_documents
    rename_table :raw_document_logs, :lr_document_logs
  end
end
