# frozen_string_literal: true

class AddOprDescriptionToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :opr_description, :string
  end
end
