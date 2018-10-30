# frozen_string_literal: true

class ChangeConformedDocumentsAddMergedAt < ActiveRecord::Migration[4.2]
  def change
    change_table :conformed_documents do |t|
      t.timestamp :merged_at
    end
  end
end
