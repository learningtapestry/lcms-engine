# frozen_string_literal: true

class DropMaterialPartsTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :material_parts
  end
end
