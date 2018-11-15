# frozen_string_literal: true

class S3Service
  def self.create_object(key)
    Aws::S3::Resource
      .new(region: ENV.fetch('AWS_REGION'))
      .bucket(ENV.fetch('AWS_S3_BUCKET_NAME'))
      .object(key)
  end

  def self.upload(key, data)
    object = create_object key
    object.put(body: data)
    object.public_url
  end

  def self.url_for(key)
    create_object(key).public_url
  end
end
