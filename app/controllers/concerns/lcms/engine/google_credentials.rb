# frozen_string_literal: true

require 'lt/google/api/auth/cli'

module Lcms
  module Engine
    module GoogleCredentials
      protected

      def google_credentials
        @google_credentials ||= Lt::Google::Api::Auth::Cli.new.credentials
      rescue StandardError
        raise "Can't get file based credentials to access Google Drive!"
      end
    end
  end
end
