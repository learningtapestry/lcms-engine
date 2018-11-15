# frozen_string_literal: true

class AddResourceTypeAndUrlToResources < Lcms::Engine::Migration
  def change
    add_column :resources, :resource_type, :integer, default: 1, null: false
    add_column :resources, :url, :string

    add_index :resources, :resource_type
  end
end
