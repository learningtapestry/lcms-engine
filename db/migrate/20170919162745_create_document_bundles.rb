# frozen_string_literal: true

class CreateDocumentBundles < Lcms::Engine::Migration
  def change
    create_table :document_bundles do |t|
      t.string :category, null: false
      t.string :file
      t.references :resource, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
