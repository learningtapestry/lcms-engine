# frozen_string_literal: true

class CreateAgeRange < ActiveRecord::Migration[4.2]
  def change
    create_table :age_ranges do |t|
      t.references :conformed_document, references: :conformed_documents
      t.integer :age

      t.timestamps
    end
  end
end
