# frozen_string_literal: true

class RemoveTypeFromStandard < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :type, :string
  end
end
