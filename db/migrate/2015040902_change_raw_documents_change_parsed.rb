# frozen_string_literal: true

class ChangeRawDocumentsChangeParsed < ActiveRecord::Migration[4.2]
  def change
    change_table :raw_documents do |t|
      t.remove :parsed
      t.timestamp :format_parsed_at
    end
  end
end
