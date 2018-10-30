# frozen_string_literal: true

class AddEllAppropriateToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :ell_appropriate, :boolean, null: false, default: false
  end
end
