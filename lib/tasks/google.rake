# frozen_string_literal: true

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'lt/google/api/auth/cli'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

namespace :google do
  desc 'set up google credentials'
  task setup_auth: :environment do
    service = ::Lt::Google::Api::Auth::Cli.new
    if service.credentials.nil?
      authorizer = service.authorizer
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts "Open \n>> #{url}\n in your browser and enter the resulting code:"
      code = $stdin.gets.strip
      authorizer.get_and_store_credentials_from_code(
        user_id: ::Lt::Google::Api::Auth::Cli::USER_ID, code: code, base_url: OOB_URI
      )
    else
      puts 'No need in action, everything is already set up'
    end
  end
end
