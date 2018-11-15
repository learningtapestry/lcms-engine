# frozen_string_literal: true

class RenameAgeRanges < Lcms::Engine::Migration
  def change
    rename_table :age_ranges, :conformed_document_age_ranges
  end
end
