# frozen_string_literal: true

class AddClusterIdToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :cluster_id, :integer
    add_foreign_key :standards, :standards, column: :cluster_id
    add_index :standards, :cluster_id
  end
end
