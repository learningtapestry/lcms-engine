# frozen_string_literal: true

module Lcms
  module Engine
    class Pagination
      PARAMS_DEFAULT = { page: 1, per_page: 20, order: :asc }.freeze

      def initialize(params)
        @params = handle_params params
      end

      def params(strict: false)
        @pagination_params ||= begin
          expected_params = @params.slice(*PARAMS_DEFAULT.keys).symbolize_keys
          pagination = PARAMS_DEFAULT.merge(expected_params)

          pagination[:page] = pagination[:page].to_i
          pagination[:per_page] = pagination[:per_page].to_i
          pagination[:order] = pagination[:order].to_sym

          raise StandardError unless pagination[:page].positive?
          raise StandardError unless pagination[:per_page].positive?
          raise StandardError unless %i(asc desc).include? pagination[:order]

          pagination
        end
        strict ? @pagination_params.slice(:page, :per_page) : @pagination_params
      end

      def serialize(resources, serializer)
        options = { root: :results }
        options[:meta_key] = :pagination
        options[:pagination] = {
          total_pages: resources.total_pages,
          current_page: resources.current_page,
          per_page: resources.per_page,
          order: params[:order],
          total_hits: resources.total_entries
        }
        options[:each_serializer] = serializer
        ActiveModel::ArraySerializer.new(resources, options).as_json
      end

      private

      def handle_params(params)
        return params unless params.is_a?(ActionController::Parameters)

        params.permit(*PARAMS_DEFAULT.keys).to_h
      end
    end
  end
end
