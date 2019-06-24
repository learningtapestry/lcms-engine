# frozen_string_literal: true

module Lcms
  module Engine
    class Download < ApplicationRecord
      CONTENT_TYPES = {
        zip: 'application/zip',
        pdf: 'application/pdf',
        excel: %w(application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet),
        powerpoint: %w(application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation), # rubocop:disable Metrics/LineLength
        doc: %w(application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)
      }.freeze
      S3_URL = 'http://k12-content.s3-website-us-east-1.amazonaws.com/'
      URL_PUBLIC_PREFIX = 'public://'

      mount_uploader :filename, DownloadUploader
      alias_attribute :file, :filename

      validates :title, presence: true
      validates :file, presence: true, if: 'url.nil?'
      validates :url, presence: true, if: 'file.nil?'

      before_save :update_metadata

      def attachment_url
        if url.present?
          url.sub(URL_PUBLIC_PREFIX, S3_URL)
        else
          file.url
        end
      end

      def s3_filename
        File.basename(attachment_url)
      end

      def attachment_content_type
        type = content_type
        CONTENT_TYPES.each do |key, types|
          if Array.wrap(types).include?(content_type)
            type = key
            break
          end
        end
        type
      end

      private

      def update_metadata
        if file.present?
          self.content_type = file.file.content_type
          self.filesize = file.file.size
        end

        true
      end
    end
  end
end
