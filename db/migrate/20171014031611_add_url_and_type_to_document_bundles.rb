# frozen_string_literal: true

class AddUrlAndTypeToDocumentBundles < ActiveRecord::Migration[4.2]
  def change
    add_column :document_bundles, :url, :string
    add_column :document_bundles, :content_type, :string, null: false, default: 'pdf'
  end
end
