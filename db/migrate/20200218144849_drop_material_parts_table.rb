# frozen_string_literal: true

class DropMaterialPartsTable < Lcms::Engine::Migration
  def change
    drop_table :material_parts
  end
end
