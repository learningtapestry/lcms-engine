# frozen_string_literal: true

module Lcms
  module Engine
    module LocationStorable
      extend ActiveSupport::Concern

      included do
        before_action :store_user_location!, if: :storable_location?
      end

      private

      def pdf_request?
        request.path.index('pdf-proxy').present?
      end

      def storable_location?
        request.get? && is_navigational_format? && !devise_controller? && !request.xhr? && !pdf_request?
      end

      def store_user_location!
        store_location_for(:user, request.fullpath)
      end
    end
  end
end
