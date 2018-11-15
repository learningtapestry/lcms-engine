# frozen_string_literal: true

class RenameLobjectsAlignments < Lcms::Engine::Migration
  def change
    rename_table :lobjects_alignments, :lobject_alignments
  end
end
