# frozen_string_literal: true

class AddSectionMetadataToDocument < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :sections_metadata, :jsonb
  end
end
