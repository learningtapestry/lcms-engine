# frozen_string_literal: true

class ChangeKeywordsAddCanonical < ActiveRecord::Migration[4.2]
  def change
    change_table :keywords do |t|
      t.references :canonical, references: :keywords
    end

    add_index :keywords, :canonical_id
  end
end
