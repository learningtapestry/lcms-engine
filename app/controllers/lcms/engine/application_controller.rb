# frozen_string_literal: true

module Lcms
  module Engine
    class ApplicationController < ActionController::Base
      # protect_from_forgery with: :null_session, prepend: true
      protect_from_forgery prepend: true

      # store location to use at after sign in or other devise callbacks
      include LocationStorable

      before_action :authenticate_user!, unless: :pdf_request?

      before_action :configure_permitted_parameters, if: :devise_controller?

      rescue_from ActiveRecord::RecordNotFound do
        render 'lcms/engine/pages/not_found', status: :not_found
      end

      protected

      # Raise translation missing errors in controllers too
      def t(key, options = {})
        options[:raise] = true
        translate(key, **options)
      end

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:access_code])
      end

      private

      def after_sign_in_path_for(resource_or_scope)
        stored_location_for(resource_or_scope) || lcms_engine.root_path
      end

      def after_sign_out_path_for(resource_or_scope)
        session_path(resource_or_scope)
      end
    end
  end
end
