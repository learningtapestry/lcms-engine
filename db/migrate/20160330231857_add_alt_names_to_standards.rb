# frozen_string_literal: true

class AddAltNamesToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :alt_names, :text, array: true, default: [], null: false
  end
end
