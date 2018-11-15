# frozen_string_literal: true

class DropLrDocumentLogs < Lcms::Engine::Migration
  def change
    drop_table :lr_document_logs
  end
end
