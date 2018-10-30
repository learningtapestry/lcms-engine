# frozen_string_literal: true

class CreateStandardLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :standard_links do |t|
      t.integer :standard_begin_id, index: true, null: false
      t.integer :standard_end_id, index: true, null: false
      t.string :link_type, index: true, null: false
      t.string :description
    end

    add_foreign_key :standard_links, :standards, column: :standard_begin_id
    add_foreign_key :standard_links, :standards, column: :standard_end_id
  end
end
