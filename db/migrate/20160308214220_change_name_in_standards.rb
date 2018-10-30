# frozen_string_literal: true

class ChangeNameInStandards < ActiveRecord::Migration[4.2]
  def change
    change_column :standards, :name, :string, null: false
  end
end
