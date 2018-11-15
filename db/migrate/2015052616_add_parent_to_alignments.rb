# frozen_string_literal: true

class AddParentToAlignments < Lcms::Engine::Migration
  def change
    change_table :alignments do |t|
      t.references :parent, references: :alignments
    end
  end
end
