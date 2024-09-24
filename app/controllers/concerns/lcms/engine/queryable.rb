# frozen_string_literal: true

module Lcms
  module Engine
    module Queryable
      extend ActiveSupport::Concern

      included do
        before_action :set_query_params
      end

      def set_query_params
        @query_params = params[:query]&.permit(*self.class::QUERY_ATTRS_KEYS, self.class::QUERY_ATTRS_NESTED) || {}
      end

      def query_struct(attrs)
        Struct.new(*self.class::QUERY_ATTRS_KEYS, keyword_init: true).new(attrs.to_h)
      end
    end
  end
end
