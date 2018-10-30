# frozen_string_literal: true

class AddStandardClusterIdToStandards < ActiveRecord::Migration[4.2]
  def change
    add_reference :standards, :standard_cluster, index: true, foreign_key: true
  end
end
