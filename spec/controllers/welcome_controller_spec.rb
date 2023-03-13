# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::WelcomeController do
  #
  # In the Host application should be a proxy which will redirect
  # request inside mounted engine
  #
  describe 'GET oauth2callback' do
    let(:code) { Faker::Lorem.words.join }

    before { request.env['HTTP_REFERER'] = Lcms::Engine::WelcomeController::OAUTH_REFERER }

    subject { get :oauth2callback, params: { code: } }

    it 'skips authorization' do
      subject
      expect(response).to be_successful
    end

    it 'renders passed in params as JSON' do
      subject
      result = JSON.parse(response.body)
      expect(result['text']).to eq Lcms::Engine::WelcomeController::OAUTH_MESSAGE
      expect(result['code']).to eq code
    end

    context 'when referer is not a Google service' do
      before { request.env['HTTP_REFERER'] = 'test.com' }

      it 'returns 404' do
        subject
        expect(response).to have_http_status(404)
      end
    end
  end
end
