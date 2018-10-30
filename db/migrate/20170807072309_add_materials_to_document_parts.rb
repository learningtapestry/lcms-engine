# frozen_string_literal: true

class AddMaterialsToDocumentParts < ActiveRecord::Migration[4.2]
  def change
    add_column :document_parts, :materials, :text, array: true, default: [], null: false
  end
end
