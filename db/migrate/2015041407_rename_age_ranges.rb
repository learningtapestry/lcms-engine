# frozen_string_literal: true

class RenameAgeRanges < ActiveRecord::Migration[4.2]
  def change
    rename_table :age_ranges, :conformed_document_age_ranges
  end
end
