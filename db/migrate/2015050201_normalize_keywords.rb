# frozen_string_literal: true

class NormalizeKeywords < Lcms::Engine::Migration
  def up
    execute <<-SQL
      update
        raw_documents
      set
        keys = lower(keys::text)::jsonb,
        payload_schema = lower(payload_schema::text)::jsonb
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
