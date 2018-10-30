# frozen_string_literal: true

class AddDownloadCategoryToLobjectDownloads < ActiveRecord::Migration[4.2]
  def change
    add_reference :lobject_downloads, :download_category, index: true, foreign_key: true
  end
end
