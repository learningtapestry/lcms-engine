# frozen_string_literal: true

class RemoveDocIdColumn < Lcms::Engine::Migration
  def change
    remove_column :subjects, :doc_id
  end
end
