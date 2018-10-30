# frozen_string_literal: true

class CreateGoogleDocStandards < ActiveRecord::Migration[4.2]
  def change
    create_table :google_doc_standards do |t|
      t.string :description, null: false
      t.string :name, null: false

      t.index :name, unique: true
    end
  end
end
