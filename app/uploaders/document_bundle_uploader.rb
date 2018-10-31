# frozen_string_literal: true

class DocumentBundleUploader < CarrierWave::Uploader::Base
  def store_dir
    "bundles/#{model.resource_id}/#{model.category}"
  end

  def fog_attributes
    { 'Content-Disposition' => 'attachment' }
  end
end
