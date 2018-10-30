# frozen_string_literal: true

class RemoveIndexedAtColumns < ActiveRecord::Migration[4.2]
  def change
    remove_column :alignments, :indexed_at
    remove_column :identities, :indexed_at
    remove_column :subjects, :indexed_at
  end
end
