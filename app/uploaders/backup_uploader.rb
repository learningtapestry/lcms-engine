# frozen_string_literal: true

class BackupUploader < CarrierWave::Uploader::Base
  def store_dir
    "resource_backups/#{model.id}"
  end
end
