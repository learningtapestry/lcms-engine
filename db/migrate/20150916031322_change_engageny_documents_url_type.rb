# frozen_string_literal: true

class ChangeEngagenyDocumentsUrlType < ActiveRecord::Migration[4.2]
  def change
    change_column :engageny_documents, :url, :text
  end
end
