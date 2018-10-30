# frozen_string_literal: true

class AddDataFieldToDocumentParts < ActiveRecord::Migration[4.2]
  def change
    add_column :document_parts, :data, :jsonb, default: {}, null: false
  end
end
