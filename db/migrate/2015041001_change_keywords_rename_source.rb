# frozen_string_literal: true

class ChangeKeywordsRenameSource < ActiveRecord::Migration[4.2]
  def change
    change_table :keywords do |t|
      t.rename :source, :doc_id
    end
  end
end
