# frozen_string_literal: true

class DropAgeRanges < Lcms::Engine::Migration
  def change
    drop_table :lobject_age_ranges
  end
end
