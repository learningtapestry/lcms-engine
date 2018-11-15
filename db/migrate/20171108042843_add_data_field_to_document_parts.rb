# frozen_string_literal: true

class AddDataFieldToDocumentParts < Lcms::Engine::Migration
  def change
    add_column :document_parts, :data, :jsonb, default: {}, null: false
  end
end
