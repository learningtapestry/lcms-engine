# frozen_string_literal: true

class RenameRawDocumentColumns < ActiveRecord::Migration[4.2]
  def change
    rename_column :conformed_documents, :raw_document_id, :lr_document_id
  end
end
