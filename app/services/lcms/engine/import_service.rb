# frozen_string_literal: true

module Lcms
  module Engine
    class ImportService
      #
      # @param [String] url
      # @return [String]
      #
      def self.call(url)
        google_credentials = Lt::Google::Api::Auth::Cli.new.credentials
        downloader = Lt::Lcms::Lesson::Downloader::Base.new google_credentials, url
        downloader.download(mime_type: 'text/csv').content
      end
    end
  end
end
