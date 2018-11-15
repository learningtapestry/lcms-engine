# frozen_string_literal: true

class ChangeKeywordsRenameSource < Lcms::Engine::Migration
  def change
    change_table :keywords do |t|
      t.rename :source, :doc_id
    end
  end
end
