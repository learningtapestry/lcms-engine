# frozen_string_literal: true

class ChangeRawDocumentsAddConformedAt < ActiveRecord::Migration[4.2]
  def change
    change_table :raw_documents do |t|
      t.timestamp :conformed_at
    end
  end
end
