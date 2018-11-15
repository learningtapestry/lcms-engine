# frozen_string_literal: true

class ChangeRawDocumentsAddConformedAt < Lcms::Engine::Migration
  def change
    change_table :raw_documents do |t|
      t.timestamp :conformed_at
    end
  end
end
