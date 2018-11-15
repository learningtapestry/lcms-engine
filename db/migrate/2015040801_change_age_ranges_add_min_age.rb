# frozen_string_literal: true

class ChangeAgeRangesAddMinAge < Lcms::Engine::Migration
  def change
    change_table :age_ranges do |t|
      t.boolean :min_age, default: false
    end
  end
end
