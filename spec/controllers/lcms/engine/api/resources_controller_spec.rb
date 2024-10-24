# frozen_string_literal: true

require 'rails_helper'

module Lcms
  module Engine
    module Api
      RSpec.describe ResourcesController, type: :controller do
        routes { Lcms::Engine::Engine.routes }

        let(:timestamp) { Time.now.to_i }
        let(:path) { "/lcms-engine/api/resources#{path_params}" }
        let(:path_params) { params.present? ? "?#{params.to_query}" : '' }
        let(:params) { {} }
        let(:signature) do
          AuthHelper.compute_hmac_signature(
            timestamp,
            path,
            '',
            ENV.fetch('API_SECRET_KEY', nil)
          )
        end

        before do
          ENV['API_SECRET_KEY'] = '3a2aa981f4ff538d4a1b45cc2c8ade0d731b689faa1db14d2701309b84993cb5'
        end

        describe 'GET #index' do
          let!(:resources) { create_list(:resource, 3) }

          it 'returns all resources' do
            request.headers['X-Api-Timestamp'] = timestamp
            request.headers['X-Api-Signature'] = signature

            get :index

            expect(response).to have_http_status(:success)
            expect(JSON.parse(response.body).length).to eq(3)
          end

          context 'when link_updated_after param is provided' do
            let!(:resource1) do
              create :resource, links: {
                ocx: {
                  url: 'http://example.com',
                  timestamp: 1.day.ago.to_i
                }
              }
            end

            let!(:resource2) do
              create :resource, links: {
                ocx: {
                  url: 'http://example.com',
                  timestamp: 2.days.ago.to_i
                }
              }
            end

            let(:after_time) { 25.hours.ago.to_i }
            let(:link_path) { 'ocx' }
            let(:link_updated_after) { "#{link_path}:#{after_time}" }

            let(:params) { { link_updated_after: } }

            it 'returns only resources with links updated after the provided time' do
              request.headers['X-Api-Timestamp'] = timestamp
              request.headers['X-Api-Signature'] = signature

              get(:index, params:)

              expect(response).to have_http_status(:success)
              expect(JSON.parse(response.body).length).to eq(1)
              expect(JSON.parse(response.body).first['id']).to eq(resource1.id)
            end
          end

          context 'when resource_type param is provided' do
            let!(:resource1) { create :resource, resource_type: 'text_set' }
            let!(:resource2) { create :resource, resource_type: 'video', url: 'https://google.com' }

            before do
              request.headers['X-Api-Timestamp'] = timestamp
              request.headers['X-Api-Signature'] = signature
            end

            context 'with resource_type=text_set' do
              let(:params) { { resource_type: 'text_set' } }

              it 'returns only resources with the provided resource_type' do
                get(:index, params:)

                expect(response).to have_http_status(:success)
                expect(JSON.parse(response.body).length).to eq(1)
                expect(JSON.parse(response.body).first['id']).to eq(resource1.id)
              end
            end

            context 'with resource_type=text_set' do
              let(:params) { { resource_type: 'video' } }

              it 'returns only resources with the provided resource_type' do
                get(:index, params:)

                expect(response).to have_http_status(:success)
                expect(JSON.parse(response.body).length).to eq(1)
                expect(JSON.parse(response.body).first['id']).to eq(resource2.id)
              end
            end
          end
        end
      end
    end
  end
end
