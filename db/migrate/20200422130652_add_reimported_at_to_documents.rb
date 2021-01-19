# frozen_string_literal: true

class AddReimportedAtToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :reimported_at, :datetime
  end
end
