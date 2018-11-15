# frozen_string_literal: true

class RemoveContentFromDocuments < Lcms::Engine::Migration
  def change
    remove_column :documents, :content, :text
  end
end
