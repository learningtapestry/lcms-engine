# frozen_string_literal: true

class ChangeMetadataDocumentToJsonb < Lcms::Engine::Migration
  def change
    remove_index :documents, :metadata
    remove_index :documents, name: 'index_document_on_units'
    remove_index :documents, name: 'index_document_on_topics'
    change_column_default :documents, :metadata, nil
    change_column :documents, :metadata, 'jsonb USING CAST(metadata AS jsonb)', default: {}, null: false
    add_index :documents, :metadata, using: :gin
    execute <<-SQL
      CREATE INDEX index_document_on_units ON documents (lower(metadata ->> 'unit'));
      CREATE INDEX index_document_on_topics ON documents (lower(metadata ->> 'topic'));
    SQL
  end
end
