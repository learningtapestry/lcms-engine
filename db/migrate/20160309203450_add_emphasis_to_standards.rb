# frozen_string_literal: true

class AddEmphasisToStandards < ActiveRecord::Migration[4.2]
  def change
    add_column :standards, :emphasis, :string
    add_index :standards, :emphasis
  end
end
