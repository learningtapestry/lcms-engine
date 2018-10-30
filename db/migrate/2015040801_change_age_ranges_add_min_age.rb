# frozen_string_literal: true

class ChangeAgeRangesAddMinAge < ActiveRecord::Migration[4.2]
  def change
    change_table :age_ranges do |t|
      t.boolean :min_age, default: false
    end
  end
end
