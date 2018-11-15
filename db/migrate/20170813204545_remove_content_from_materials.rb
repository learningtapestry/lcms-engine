# frozen_string_literal: true

class RemoveContentFromMaterials < Lcms::Engine::Migration
  def change
    remove_column :materials, :content, :text
  end
end
