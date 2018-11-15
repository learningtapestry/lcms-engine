# frozen_string_literal: true

class AddStandardClusterIdToStandards < Lcms::Engine::Migration
  def change
    add_reference :standards, :standard_cluster, index: true, foreign_key: true
  end
end
