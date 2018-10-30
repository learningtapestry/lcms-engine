# frozen_string_literal: true

class DropLrDocumentLogs < ActiveRecord::Migration[4.2]
  def change
    drop_table :lr_document_logs
  end
end
