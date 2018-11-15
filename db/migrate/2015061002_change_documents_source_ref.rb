# frozen_string_literal: true

class ChangeDocumentsSourceRef < Lcms::Engine::Migration
  def up
    add_column :documents, :source_document_id, :integer, index: true
    add_foreign_key :documents, :source_documents
    remove_column :documents, :lr_document_id
  end

  def down
    add_column :documents, :lr_document_id, :integer, index: true
    add_foreign_key :documents, :lr_documents
    remove_column :documents, :source_document_id
  end
end
