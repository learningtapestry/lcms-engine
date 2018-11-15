# frozen_string_literal: true

class RevertRawDocumentsResourceData < Lcms::Engine::Migration
  def change
    change_table :raw_documents do |t|
      t.json    :resource_data_json
      t.xml     :resource_data_xml
      t.text    :resource_data_string

      t.remove :resource_data
    end
  end
end
