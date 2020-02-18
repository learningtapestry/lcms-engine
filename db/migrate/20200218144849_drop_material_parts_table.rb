# frozen_string_literal: true

class DropMaterialPartsTable < ActiveRecord::Migration
  def change
    drop_table :material_parts
  end
end
