# frozen_string_literal: true

class AddClusterToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :cluster, :string, index: true
    add_index :standards, :cluster
  end
end
