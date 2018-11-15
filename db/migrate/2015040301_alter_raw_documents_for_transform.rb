# frozen_string_literal: true

class AlterRawDocumentsForTransform < Lcms::Engine::Migration
  def change
    change_table :raw_documents do |t|
      t.remove :identity
      t.remove :keys
      t.remove :payload_schema
    end

    change_table :raw_documents do |t|
      t.json :identity
      t.json :keys
      t.json :payload_schema
    end
  end
end
