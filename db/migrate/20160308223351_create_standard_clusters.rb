# frozen_string_literal: true

class CreateStandardClusters < Lcms::Engine::Migration
  def change
    create_table :standard_clusters do |t|
      t.string :name, null: false
      t.string :heading
    end
  end
end
