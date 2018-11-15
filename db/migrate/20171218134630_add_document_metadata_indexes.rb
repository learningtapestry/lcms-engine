# frozen_string_literal: true

class AddDocumentMetadataIndexes < Lcms::Engine::Migration
  def up
    execute <<-SQL
      CREATE INDEX index_document_on_units ON documents (lower(metadata -> 'unit'));
      CREATE INDEX index_document_on_topics ON documents (lower(metadata -> 'topic'));
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX index_document_on_units;
      DROP INDEX index_document_on_topics;
    SQL
  end
end
