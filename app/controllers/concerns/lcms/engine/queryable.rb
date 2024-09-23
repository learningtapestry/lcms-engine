# frozen_string_literal: true

module Lcms
  module Engine
    module Queryable
      extend ActiveSupport::Concern

      included do
        before_action :set_query_params
      end

      def set_query_params
        @query_params = params[:query]&.permit(*QUERY_ATTRS_KEYS, QUERY_ATTRS_NESTED) || {}
      end

      def query_struct(attrs)
        Struct.new(*QUERY_ATTRS_KEYS, keyword_init: true).new(attrs.to_h)
      end
    end
  end
end
