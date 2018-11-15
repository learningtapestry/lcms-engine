# frozen_string_literal: true

class ChangeEngagenyDocumentsUrlType < Lcms::Engine::Migration
  def change
    change_column :engageny_documents, :url, :text
  end
end
