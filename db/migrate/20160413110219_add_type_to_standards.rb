# frozen_string_literal: true

class AddTypeToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :type, :string
    add_index :standards, :type
  end
end
