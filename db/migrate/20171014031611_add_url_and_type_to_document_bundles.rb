# frozen_string_literal: true

class AddUrlAndTypeToDocumentBundles < Lcms::Engine::Migration
  def change
    add_column :document_bundles, :url, :string
    add_column :document_bundles, :content_type, :string, null: false, default: 'pdf'
  end
end
