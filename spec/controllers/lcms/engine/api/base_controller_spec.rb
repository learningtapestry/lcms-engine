# frozen_string_literal: true

require 'rails_helper'

module Lcms
  module Engine
    module Api
      RSpec.describe BaseController, type: :controller do
        controller do
          def index
            render json: { status: 'ok' }
          end
        end

        before do
          ENV['API_SECRET_KEY'] = '3a2aa981f4ff538d4a1b45cc2c8ade0d731b689faa1db14d2701309b84993cb5'
          routes.draw { get 'index' => 'lcms/engine/api/base#index' }
        end

        describe '#authenticate_request' do
          let(:timestamp) { Time.now.to_i }
          let(:path) { '/index' }
          let(:signature) do
            AuthHelper.compute_hmac_signature(
              timestamp,
              path,
              '',
              ENV.fetch('API_SECRET_KEY', nil)
            )
          end

          context 'with valid authentication' do
            it 'allows the request' do
              request.headers['X-Api-Timestamp'] = timestamp
              request.headers['X-Api-Signature'] = signature
              get :index
              expect(response).to have_http_status(:success)
            end
          end

          context 'with missing headers' do
            it 'returns unauthorized' do
              get :index
              expect(response).to have_http_status(:unauthorized)
              expect(JSON.parse(response.body)['error']).to eq('Missing authentication headers')
            end
          end

          context 'with expired timestamp' do
            it 'returns unauthorized' do
              request.headers['X-Api-Timestamp'] = 6.minutes.ago.to_i
              request.headers['X-Api-Signature'] = signature
              get :index
              expect(response).to have_http_status(:unauthorized)
              expect(JSON.parse(response.body)['error']).to eq('Request expired')
            end
          end

          context 'with invalid signature' do
            it 'returns unauthorized' do
              request.headers['X-Api-Timestamp'] = timestamp
              request.headers['X-Api-Signature'] = 'invalid_signature'
              get :index
              expect(response).to have_http_status(:unauthorized)
              expect(JSON.parse(response.body)['error']).to eq('Invalid signature')
            end
          end
        end
      end
    end
  end
end
