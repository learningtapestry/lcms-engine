# frozen_string_literal: true

class DropStandardStrand < Lcms::Engine::Migration
  def change
    remove_column :standards, :standard_strand_id, :integer
    drop_table :standard_strands do |t|
      t.string :name, null: false
      t.string :heading
    end
  end
end
