# frozen_string_literal: true

class RemoveContentFromMaterials < ActiveRecord::Migration[4.2]
  def change
    remove_column :materials, :content, :text
  end
end
