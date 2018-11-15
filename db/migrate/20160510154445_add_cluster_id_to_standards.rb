# frozen_string_literal: true

class AddClusterIdToStandards < Lcms::Engine::Migration
  def change
    add_column :standards, :cluster_id, :integer
    add_foreign_key :standards, :standards, column: :cluster_id
    add_index :standards, :cluster_id
  end
end
