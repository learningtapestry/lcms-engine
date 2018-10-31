# frozen_string_literal: true

class SocialThumbnailUploader < CarrierWave::Uploader::Base
  def store_dir
    "social_thumbnails/#{mounted_as}/#{model.id}"
  end

  # def fog_attributes
  #   { 'Content-Disposition' => 'attachment' }
  # end
end
