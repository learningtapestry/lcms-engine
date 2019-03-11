# frozen_string_literal: true

require 'lt/google/api/auth/cli'

module Lcms
  module Engine
    module GoogleCredentials
      protected

      def google_credentials
        @google_credentials ||= Lt::Google::Api::Auth::Cli.new.credentials
      end
    end
  end
end
