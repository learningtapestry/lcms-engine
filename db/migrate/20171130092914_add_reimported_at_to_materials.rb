# frozen_string_literal: true

class AddReimportedAtToMaterials < Lcms::Engine::Migration
  def change
    add_column :materials, :reimported_at, :timestamp
  end
end
