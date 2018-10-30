# frozen_string_literal: true

class ChangeStandards < ActiveRecord::Migration[4.2]
  def change
    change_column :standards, :name, :string, null: true

    add_column :standards, :alt_name, :string
    add_column :standards, :asn_identifier, :string
    add_column :standards, :description, :string
    add_column :standards, :grades, :text, array: true, default: [], null: false
    add_column :standards, :label, :string

    add_index :standards, :asn_identifier, unique: true
  end
end
