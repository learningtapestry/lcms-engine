# frozen_string_literal: true

class DownloadUploader < CarrierWave::Uploader::Base
  def store_dir
    "attachments/#{model.id}"
  end

  def fog_attributes
    { 'Content-Disposition' => 'attachment' }
  end
end
