# frozen_string_literal: true

CarrierWave.configure do |config|
  if Rails.env.development? && ENV['AWS_ACCESS_KEY_ID'].blank?
    config.storage = :file
  else
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: ENV['AWS_REGION']
    }
    config.fog_directory = ENV['AWS_S3_BUCKET_NAME']
    config.fog_public = true
    config.storage = :fog
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
