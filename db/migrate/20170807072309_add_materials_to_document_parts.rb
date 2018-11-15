# frozen_string_literal: true

class AddMaterialsToDocumentParts < Lcms::Engine::Migration
  def change
    add_column :document_parts, :materials, :text, array: true, default: [], null: false
  end
end
