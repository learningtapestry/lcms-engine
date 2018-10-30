# frozen_string_literal: true

class AddTeaserToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :teaser, :string
  end
end
