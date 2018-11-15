# frozen_string_literal: true

class CreateDocumentsMaterials < Lcms::Engine::Migration
  def change
    create_table :documents_materials, id: false do |t|
      t.references :document, foreign_key: true
      t.references :material, foreign_key: true, index: true
    end

    add_index :documents_materials, %i(document_id material_id), unique: true
  end
end
