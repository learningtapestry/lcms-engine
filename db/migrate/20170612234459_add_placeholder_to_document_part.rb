# frozen_string_literal: true

class AddPlaceholderToDocumentPart < Lcms::Engine::Migration
  def change
    add_column :document_parts, :placeholder, :string
    add_index :document_parts, :placeholder
  end
end
