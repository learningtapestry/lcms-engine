# frozen_string_literal: true

class RemoveDocIdColumn < ActiveRecord::Migration[4.2]
  def change
    remove_column :subjects, :doc_id
  end
end
