# frozen_string_literal: true

class RemoveContentFromDocuments < ActiveRecord::Migration[4.2]
  def change
    remove_column :documents, :content, :text
  end
end
