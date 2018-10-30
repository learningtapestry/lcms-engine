# frozen_string_literal: true

class RenameAlignmentsToStandards < ActiveRecord::Migration[4.2]
  def change
    rename_column :resource_alignments, :alignment_id, :standard_id
    rename_table :resource_alignments, :resource_standards
    rename_table :alignments, :standards
  end
end
