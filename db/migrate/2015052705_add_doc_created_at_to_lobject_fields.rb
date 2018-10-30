# frozen_string_literal: true

class AddDocCreatedAtToLobjectFields < ActiveRecord::Migration[4.2]
  def change
    add_column :lobject_titles, :doc_created_at, :timestamp
    add_column :lobject_descriptions, :doc_created_at, :timestamp
  end
end
