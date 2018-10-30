# frozen_string_literal: true

class RenameCanonicalColumns < ActiveRecord::Migration[4.2]
  def change
    rename_column :keywords, :canonical_id, :parent_id
    rename_column :urls, :canonical_id, :parent_id
  end
end
