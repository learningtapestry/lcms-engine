# frozen_string_literal: true

module Lcms
  module Engine
    module Api
      class BaseController < ActionController::Base
        protect_from_forgery with: :null_session

        before_action :authenticate_request

        API_REQUEST_EXPIRATION_SECONDS = 300

        private

        def authenticate_request
          timestamp = request.headers['X-Api-Timestamp']
          signature = request.headers['X-Api-Signature']

          unless timestamp && signature
            render json: { error: 'Missing authentication headers' }, status: :unauthorized
            return
          end

          # Verify timestamp is within 5 minutes
          if (Time.now.to_i - timestamp.to_i).abs > API_REQUEST_EXPIRATION_SECONDS
            render json: { error: 'Request expired' }, status: :unauthorized
            return
          end

          # Calculate expected signature
          expected_signature = AuthHelper.compute_hmac_signature(
            timestamp,
            request.fullpath,
            request.raw_post,
            ENV.fetch('API_SECRET_KEY')
          )

          signature_valid = ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)

          render json: { error: 'Invalid signature' }, status: :unauthorized unless signature_valid
        end
      end
    end
  end
end
