# frozen_string_literal: true

class DropStandardClusters < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :standard_cluster_id
    drop_table :standard_clusters
  end
end
