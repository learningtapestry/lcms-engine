# frozen_string_literal: true

class CreateTopics < ActiveRecord::Migration[4.2]
  def change
    create_table :topics do |t|
      t.string :name, index: true
      t.references :parent, index: true
      t.timestamps null: false
    end

    create_table :document_topics do |t|
      t.references :document
      t.references :topic
      t.timestamps null: false
    end

    create_table :lobject_topics do |t|
      t.references :lobject
      t.references :document
      t.references :topic
      t.timestamps null: false
    end
  end
end
