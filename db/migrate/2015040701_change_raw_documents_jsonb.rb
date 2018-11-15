# frozen_string_literal: true

class ChangeRawDocumentsJsonb < Lcms::Engine::Migration
  def up
    execute 'alter table raw_documents alter column identity set data type jsonb using identity::jsonb;'
    execute 'alter table raw_documents alter column payload_schema set data type jsonb using payload_schema::jsonb;'
    execute 'alter table raw_documents alter column keys set data type jsonb using keys::jsonb;'

    execute 'create index raw_doc_ide_gin on raw_documents using gin (identity);'
    execute 'create index raw_doc_pay_sch_gin on raw_documents using gin (payload_schema);'
    execute 'create index raw_doc_key_gin on raw_documents using gin (keys);'
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
