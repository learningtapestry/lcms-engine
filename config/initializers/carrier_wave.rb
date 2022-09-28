# frozen_string_literal: true

require 'fog/aws'

CarrierWave.configure do |config|
  if (Rails.env.development? && ENV['AWS_ACCESS_KEY_ID'].blank?) || Rails.env.test?
    config.storage = :file
  else
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil),
      region: ENV.fetch('AWS_REGION', nil)
    }
    config.fog_directory = ENV.fetch('AWS_S3_BUCKET_NAME', nil)
    config.fog_public = true
    config.storage = :fog
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
