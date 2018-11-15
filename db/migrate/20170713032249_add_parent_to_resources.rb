# frozen_string_literal: true

class AddParentToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :parent_id, :integer
    add_column :resources, :level_position, :integer
  end
end
