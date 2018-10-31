# frozen_string_literal: true

class StaffImageUploader < CarrierWave::Uploader::Base
  def store_dir
    "staff_images/#{model.id}"
  end
end
