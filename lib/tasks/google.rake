# frozen_string_literal: true

require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'lt/google/api/auth/cli'

namespace :google do
  desc 'Set up google credentials. Specify `domain` argument which will be used as a base for redirect URI'
  task :setup_auth, [:domain] => [:environment] do |_task, args|
    service = ::Lt::Google::Api::Auth::Cli.new

    # Check if there is existing auth token
    if service.credentials.present?
      puts <<~TEXT
        Auth token already exists. Do you want to request new one?
        Type Y for Yes, N for No
      TEXT
      next unless $stdin.gets.to_s.strip.downcase == 'y'
    end

    authorizer = service.authorizer
    url = authorizer.get_authorization_url(base_url: args[:domain])

    puts <<~TEXT
      Open this URL in your browser:
      >>>>>
      #{url}
      >>>>>
      Copy auth code and paste it below.
    TEXT

    code = $stdin.gets.to_s.strip

    authorizer.get_and_store_credentials_from_code(
      user_id: ::Lt::Google::Api::Auth::Cli::USER_ID,
      code:,
      base_url: args[:domain]
    )
  end
end
