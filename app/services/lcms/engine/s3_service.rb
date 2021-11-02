# frozen_string_literal: true

require 'aws-sdk-s3'

module Lcms
  module Engine
    class S3Service
      def self.create_object(key)
        ::Aws::S3::Resource
          .new(region: ENV.fetch('AWS_REGION'))
          .bucket(ENV.fetch('AWS_S3_BUCKET_NAME'))
          .object(key)
      end

      #
      # Upload data to the specified resource by key
      #
      # @param [String] key Key of the object. Usually represents the full path inside a bucket
      # @param [IO|StringIO] data The data to be uploaded
      # @param [Hash] options Additional options to be passed to Aws::S3::Object#put method
      #
      # @return [String] The final URL of the uploaded object
      #
      def self.upload(key, data, options = {})
        object = create_object key
        options = options.merge(
          body: data
        )
        object.put(options)
        object.public_url
      end

      def self.url_for(key)
        create_object(key).public_url
      end
    end
  end
end
