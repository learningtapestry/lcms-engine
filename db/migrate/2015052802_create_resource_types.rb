# frozen_string_literal: true

class CreateResourceTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :resource_types do |t|
      t.string :name, index: true
      t.references :parent, index: true
      t.timestamps null: false
    end

    create_table :documents_resource_types do |t|
      t.references :document
      t.references :resource_type
      t.timestamps null: false
    end

    create_table :lobject_resource_types do |t|
      t.references :lobject
      t.references :document
      t.references :resource_type
      t.timestamps null: false
    end
  end
end
