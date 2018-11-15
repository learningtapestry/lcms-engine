# frozen_string_literal: true

class DropStandardClusters < Lcms::Engine::Migration
  def change
    remove_column :standards, :standard_cluster_id
    drop_table :standard_clusters
  end
end
