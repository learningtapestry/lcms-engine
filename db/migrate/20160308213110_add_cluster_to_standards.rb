# frozen_string_literal: true

class AddClusterToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :cluster, :string, index: true
    add_index :standards, :cluster
  end
end
