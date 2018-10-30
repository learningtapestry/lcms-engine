# frozen_string_literal: true

class AddContextTypeToDocumentPart < ActiveRecord::Migration[4.2]
  def change
    add_column :document_parts, :context_type, :integer, default: 0
    add_index :document_parts, :context_type
  end
end
