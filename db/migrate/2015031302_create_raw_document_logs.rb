# frozen_string_literal: true

class CreateRawDocumentLogs < Lcms::Engine::Migration
  def change
    create_table :raw_document_logs do |t|
      t.string  :action
      t.date    :newest_import_date

      t.timestamps
    end
  end
end
