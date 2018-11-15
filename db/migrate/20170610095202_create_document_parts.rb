# frozen_string_literal: true

class CreateDocumentParts < Lcms::Engine::Migration
  def change
    create_table :document_parts do |t|
      t.references :document, index: true, foreign_key: true
      t.text :content
      t.string :part_type
      t.boolean :active
      t.references :parent, index: true

      t.timestamps null: false
    end
  end
end
