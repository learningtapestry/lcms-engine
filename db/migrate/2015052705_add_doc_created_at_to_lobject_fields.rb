# frozen_string_literal: true

class AddDocCreatedAtToLobjectFields < Lcms::Engine::Migration
  def change
    add_column :lobject_titles, :doc_created_at, :timestamp
    add_column :lobject_descriptions, :doc_created_at, :timestamp
  end
end
