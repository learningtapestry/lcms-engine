# frozen_string_literal: true

require 'rails_helper'

describe 'Devise Registrations', type: :request do
  let(:access_code) { create(:access_code) }

  describe 'POST /users (sign up)' do
    let(:valid_params) do
      {
        user: {
          access_code: access_code.code,
          email: 'newuser@test.com',
          name: 'New User',
          password: '12345678',
          password_confirmation: '12345678'
        }
      }
    end

    it 'creates a user and redirects to sign in page without auto-login' do
      expect do
        post lcms_engine.user_registration_path, params: valid_params
      end.to change(Lcms::Engine::User, :count).by(1)

      expect(response).to redirect_to(lcms_engine.new_user_session_path)
      expect(flash[:notice]).to eq(I18n.t('devise.registrations.signed_up'))
    end

    it 'does not authenticate the new user automatically' do
      post lcms_engine.user_registration_path, params: valid_params

      get lcms_engine.root_path
      expect(response).to redirect_to(lcms_engine.new_user_session_path)
    end

    context 'when access_code is missing' do
      it 'does not create a user' do
        params = valid_params.deep_dup
        params[:user][:access_code] = ''

        expect do
          post lcms_engine.user_registration_path, params: params
        end.not_to change(Lcms::Engine::User, :count)
      end
    end

    context 'when password is too short' do
      it 'does not create a user' do
        params = valid_params.deep_dup
        params[:user][:password] = 'short'
        params[:user][:password_confirmation] = 'short'

        expect do
          post lcms_engine.user_registration_path, params: params
        end.not_to change(Lcms::Engine::User, :count)
      end
    end
  end
end
