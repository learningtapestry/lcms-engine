# frozen_string_literal: true

class AddHierarchicalPositionToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :hierarchical_position, :string, index: true
  end

  # def data
  #   GenerateHierarchicalPositions.new.generate!
  # end
end
