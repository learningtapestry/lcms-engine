# frozen_string_literal: true

class RemoveClusterFromStandards < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :cluster
  end
end
