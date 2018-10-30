# frozen_string_literal: true

class CreateLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :languages do |t|
      t.string :name, index: true
      t.references :parent, index: true
      t.timestamps null: false
    end

    create_table :documents_languages do |t|
      t.references :document
      t.references :language
      t.timestamps null: false
    end

    create_table :lobject_languages do |t|
      t.references :lobject
      t.references :document
      t.references :language
      t.timestamps null: false
    end
  end
end
