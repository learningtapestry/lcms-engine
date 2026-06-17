# frozen_string_literal: true

require 'rails_helper'

describe 'Devise Passwords', type: :request do
  let!(:user) { create(:user) }

  describe 'POST /users/password (request reset)' do
    it 'enqueues a reset password email and redirects to sign in' do
      expect do
        post lcms_engine.user_password_path,
             params: { user: { email: user.email } }
      end.to change { ActionMailer::Base.deliveries.size }.by(1)

      expect(response).to redirect_to(lcms_engine.new_user_session_path)
    end

    it 'sets a reset_password_token on the user' do
      post lcms_engine.user_password_path,
           params: { user: { email: user.email } }

      expect(user.reload.reset_password_token).to be_present
    end
  end

  describe 'PUT /users/password (apply reset)' do
    let(:raw_token) { user.send(:set_reset_password_token) }

    it 'updates password with a valid token' do
      put lcms_engine.user_password_path,
          params: {
            user: {
              reset_password_token: raw_token,
              password: 'new-password-1',
              password_confirmation: 'new-password-1'
            }
          }

      expect(response).to redirect_to(lcms_engine.root_path)
      expect(user.reload.valid_password?('new-password-1')).to be true
    end

    it 'rejects an invalid token' do
      put lcms_engine.user_password_path,
          params: {
            user: {
              reset_password_token: 'invalid-token',
              password: 'new-password-1',
              password_confirmation: 'new-password-1'
            }
          }

      expect(user.reload.valid_password?('new-password-1')).to be false
    end
  end
end
