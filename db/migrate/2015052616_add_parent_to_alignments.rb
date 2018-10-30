# frozen_string_literal: true

class AddParentToAlignments < ActiveRecord::Migration[4.2]
  def change
    change_table :alignments do |t|
      t.references :parent, references: :alignments
    end
  end
end
