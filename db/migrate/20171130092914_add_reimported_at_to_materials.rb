# frozen_string_literal: true

class AddReimportedAtToMaterials < ActiveRecord::Migration[4.2]
  def change
    add_column :materials, :reimported_at, :timestamp
  end
end
