# frozen_string_literal: true

class AddThumbnailsLastUpdateToSettings < Lcms::Engine::Migration
  def change
    add_column :settings, :thumbnails_last_update, :datetime
  end
end
