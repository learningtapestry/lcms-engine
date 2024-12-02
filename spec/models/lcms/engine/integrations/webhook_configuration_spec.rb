# frozen_string_literal: true

require 'rails_helper'

module Lcms
  module Engine
    module Integrations
      describe WebhookConfiguration, type: :model do
        describe '#execute_call' do
          let(:config) { build :webhook_configuration }
          let(:payload) { { foo: 'bar' } }

          it 'executes call' do
            expect(HTTParty).to receive(:send).with(
              config.action.downcase.to_sym,
              config.endpoint_url,
              body: payload.to_json,
              headers: {
                'Content-Type' => 'application/json'
              }.merge(config.send(:auth_headers)),
              timeout: 30
            ).and_return(double(success?: true))

            config.execute_call(payload)
          end
        end

        describe '#auth_headers' do
          context 'when auth type is basic' do
            let(:config) { build :webhook_configuration, :basic_auth }

            it 'returns basic auth headers' do
              expect(config.send(:auth_headers)).to eq(
                'Authorization' =>
                  "Basic #{Base64.strict_encode64(
                    "#{config.auth_credentials['username']}:#{config.auth_credentials['password']}"
                  )}"
              )
            end
          end

          context 'when auth type is bearer' do
            let(:config) { build :webhook_configuration, :bearer_auth }

            it 'returns bearer auth headers' do
              expect(config.send(:auth_headers)).to eq(
                'Authorization' => "Bearer #{config.auth_credentials['token']}"
              )
            end
          end

          context 'when auth type is hmac' do
            let(:config) { build :webhook_configuration, :hmac_auth }
            let(:payload) { { test: 'data' } }
            let(:current_time) { Time.now.to_i.to_s }
            let(:expected_signature) do
              path = URI(config.endpoint_url).path

              Lcms::Engine::Api::AuthHelper.compute_hmac_signature(
                current_time,
                path,
                payload.to_json,
                config.auth_credentials['secret_key']
              )
            end

            it 'returns HMAC signature header' do
              expect(config.send(:auth_headers, payload)).to eq(
                'X-HMAC-Signature' => expected_signature,
                'X-Timestamp' => current_time
              )
            end
          end
        end
      end
    end
  end
end
