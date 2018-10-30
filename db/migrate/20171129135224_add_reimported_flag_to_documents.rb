# frozen_string_literal: true

class AddReimportedFlagToDocuments < ActiveRecord::Migration[4.2]
  def change
    add_column :documents, :reimported, :boolean, default: true, null: false
  end
end
