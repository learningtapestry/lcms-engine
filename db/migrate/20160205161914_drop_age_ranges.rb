# frozen_string_literal: true

class DropAgeRanges < ActiveRecord::Migration[4.2]
  def change
    drop_table :lobject_age_ranges
  end
end
