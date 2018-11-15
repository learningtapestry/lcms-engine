# frozen_string_literal: true

class RenameCanonicalColumns < Lcms::Engine::Migration
  def change
    rename_column :keywords, :canonical_id, :parent_id
    rename_column :urls, :canonical_id, :parent_id
  end
end
