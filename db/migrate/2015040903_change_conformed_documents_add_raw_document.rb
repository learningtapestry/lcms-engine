# frozen_string_literal: true

class ChangeConformedDocumentsAddRawDocument < ActiveRecord::Migration[4.2]
  def change
    change_table :conformed_documents do |t|
      t.references :raw_document, references: :raw_documents
    end
  end
end
