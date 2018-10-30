# frozen_string_literal: true

class DropStandardStrand < ActiveRecord::Migration[4.2]
  def change
    remove_column :standards, :standard_strand_id, :integer
    drop_table :standard_strands do |t|
      t.string :name, null: false
      t.string :heading
    end
  end
end
