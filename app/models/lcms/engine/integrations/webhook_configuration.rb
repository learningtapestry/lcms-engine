# frozen_string_literal: true

module Lcms
  module Engine
    module Integrations
      class WebhookConfiguration < ApplicationRecord
        validates :event_name, :endpoint_url, presence: true
        validates :endpoint_url, url: true
        validates :action, inclusion: { in: %w(post put patch delete) }
        validates :auth_type, inclusion: { in: %w(basic bearer hmac) }, allow_blank: true

        scope :active, -> { where(active: true) }

        CALL_TIMEOUT_SECONDS = 30

        def self.trigger(event_name, payload)
          active.where(event_name: event_name).each do |config|
            Integrations::WebhookCallJob.perform_later(config.id, payload)
          end
        end

        class WebhookCallError < StandardError; end

        def execute_call(payload)
          response = HTTParty.send(
            action.downcase.to_sym,
            endpoint_url,
            body: payload.to_json,
            headers: {
              'Content-Type' => 'application/json'
            }.merge(auth_headers(payload)),
            timeout: CALL_TIMEOUT_SECONDS
          )

          if response.success?
            Rails.logger.info("Webhook call successful: #{event_name} to #{endpoint_url}")
          else
            error_message =
              "Webhook call failed: #{event_name} to #{endpoint_url}. Status: #{response.code}, Body: #{response.body}"
            Rails.logger.error(error_message)

            raise WebhookCallError, error_message if should_retry?(response.code)
          end

          response
        rescue StandardError => e
          error_message = "Webhook call error: #{event_name} to #{endpoint_url}. Error: #{e.message}"
          Rails.logger.error(error_message)
          raise WebhookCallError, error_message
        end

        private

        def auth_headers(payload = nil)
          case auth_type
          when 'basic'
            {
              'Authorization' =>
                "Basic #{Base64.strict_encode64("#{auth_credentials['username']}:#{auth_credentials['password']}")}"
            }
          when 'bearer'
            { 'Authorization' => "Bearer #{auth_credentials['token']}" }
          when 'hmac'
            timestamp = Time.now.to_i.to_s
            {
              'X-HMAC-Signature' => generate_hmac_signature(timestamp, payload),
              'X-Timestamp' => timestamp
            }
          else
            {}
          end
        end

        def generate_hmac_signature(timestamp, payload)
          secret_key = auth_credentials['secret_key']
          path = URI(endpoint_url).path
          Lcms::Engine::Api::AuthHelper.compute_hmac_signature(timestamp, path, payload.to_json, secret_key)
        end

        def should_retry?(status_code)
          # Retry for server errors (5xx) and certain client errors
          status_code.to_i >= 500 || [408, 429].include?(status_code.to_i)
        end
      end
    end
  end
end
