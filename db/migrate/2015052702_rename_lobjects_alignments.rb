# frozen_string_literal: true

class RenameLobjectsAlignments < ActiveRecord::Migration[4.2]
  def change
    rename_table :lobjects_alignments, :lobject_alignments
  end
end
