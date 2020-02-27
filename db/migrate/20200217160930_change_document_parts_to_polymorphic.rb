# frozen_string_literal: true

class ChangeDocumentPartsToPolymorphic < Lcms::Engine::Migration
  def up
    add_reference :document_parts, :renderer, polymorphic: true, index: true
    Lcms::Engine::DocumentPart.update_all("renderer_id = document_id, renderer_type = 'Lcms::Engine::Document'")
    Lcms::Engine::MaterialPart.find_each do |material_part|
      Lcms::Engine::DocumentPart.create!(
        active: material_part.active,
        content: material_part.content,
        context_type: material_part.context_type,
        part_type: material_part.part_type,
        renderer_id: material_part.material_id,
        renderer_type: 'Lcms::Engine::Material'
      )
    end
    remove_column :document_parts, :document_id
  end

  def down
    Lcms::Engine::MaterialPart.delete_all
    Lcms::Engine::DocumentPart.where(renderer_type: 'Lcms::Engine::Material').find_each do |material_part|
      Lcms::Engine::MaterialPart.create!(
        active: material_part.active,
        content: material_part.content,
        context_type: material_part.context_type,
        part_type: material_part.part_type,
        material_id: material_part.renderer_id
      )
    end
    Lcms::Engine::DocumentPart.where(renderer_type: 'Lcms::Engine::Material').delete_all
    add_reference :document_parts, :document, index: true, foreign_key: true
    Lcms::Engine::DocumentPart.update_all('document_id = renderer_id')
    remove_reference :document_parts, :renderer, polymorphic: true
  end
end
