# frozen_string_literal: true

class AddAnchorToDocumentPart < ActiveRecord::Migration[4.2]
  def change
    add_column :document_parts, :anchor, :string
    add_index :document_parts, :anchor
  end
end
