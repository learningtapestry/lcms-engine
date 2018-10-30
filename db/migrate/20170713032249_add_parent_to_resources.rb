# frozen_string_literal: true

class AddParentToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :parent_id, :integer
    add_column :resources, :level_position, :integer
  end
end
