# frozen_string_literal: true

class RemoveEmphasisFromStandards < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :emphasis
  end
end
