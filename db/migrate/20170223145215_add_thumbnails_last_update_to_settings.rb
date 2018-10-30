# frozen_string_literal: true

class AddThumbnailsLastUpdateToSettings < ActiveRecord::Migration[4.2]
  def change
    add_column :settings, :thumbnails_last_update, :datetime
  end
end
