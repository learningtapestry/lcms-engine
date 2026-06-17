# frozen_string_literal: true

require 'rails_helper'

describe 'Devise Sessions', type: :request do
  let(:user) { create(:user) }

  describe 'POST /users/sign_in' do
    it 'signs the user in with valid credentials' do
      post lcms_engine.user_session_path,
           params: { user: { email: user.email, password: '12345678' } }

      expect(response).to redirect_to(lcms_engine.root_path)

      get lcms_engine.root_path
      expect(response).to have_http_status(:ok)
    end

    it 'rejects invalid credentials' do
      post lcms_engine.user_session_path,
           params: { user: { email: user.email, password: 'wrong-password' } }

      expect(response.body).to match(/Invalid email or password/i)

      get lcms_engine.root_path
      expect(response).to redirect_to(lcms_engine.new_user_session_path)
    end
  end

  describe 'GET /users/sign_out (sign_out_via :get)' do
    before { sign_in user }

    it 'signs the user out' do
      get lcms_engine.destroy_user_session_path
      expect(response).to redirect_to(lcms_engine.new_user_session_path)

      get lcms_engine.root_path
      expect(response).to redirect_to(lcms_engine.new_user_session_path)
    end
  end
end
