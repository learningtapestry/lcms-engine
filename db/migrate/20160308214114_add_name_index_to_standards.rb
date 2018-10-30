# frozen_string_literal: true

class AddNameIndexToStandards < ActiveRecord::Migration[4.2]
  def change
    add_index :standards, :name
  end
end
