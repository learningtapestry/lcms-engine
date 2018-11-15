# frozen_string_literal: true

class ChangeConformedDocumentsAddMergedAt < Lcms::Engine::Migration
  def change
    change_table :conformed_documents do |t|
      t.timestamp :merged_at
    end
  end
end
