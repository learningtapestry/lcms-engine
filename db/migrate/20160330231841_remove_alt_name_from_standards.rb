# frozen_string_literal: true

class RemoveAltNameFromStandards < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :alt_name
  end
end
