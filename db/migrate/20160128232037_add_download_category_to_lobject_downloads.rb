# frozen_string_literal: true

class AddDownloadCategoryToLobjectDownloads < Lcms::Engine::Migration
  def change
    add_reference :lobject_downloads, :download_category, index: true, foreign_key: true
  end
end
