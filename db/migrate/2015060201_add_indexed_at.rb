# frozen_string_literal: true

class AddIndexedAt < ActiveRecord::Migration[4.2]
  def change
    add_column :alignments, :indexed_at, :datetime
    add_column :keywords, :indexed_at, :datetime
    add_column :identities, :indexed_at, :datetime

    add_index :alignments, :indexed_at
    add_index :keywords, :indexed_at
    add_index :identities, :indexed_at
  end
end
