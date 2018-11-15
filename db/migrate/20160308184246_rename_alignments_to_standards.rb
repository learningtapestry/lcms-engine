# frozen_string_literal: true

class RenameAlignmentsToStandards < Lcms::Engine::Migration
  def change
    rename_column :resource_alignments, :alignment_id, :standard_id
    rename_table :resource_alignments, :resource_standards
    rename_table :alignments, :standards
  end
end
