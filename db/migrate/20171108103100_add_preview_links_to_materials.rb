# frozen_string_literal: true

class AddPreviewLinksToMaterials < Lcms::Engine::Migration
  def change
    add_column :materials, :preview_links, :jsonb, default: {}
  end
end
