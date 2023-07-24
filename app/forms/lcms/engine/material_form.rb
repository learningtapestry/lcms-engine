# frozen_string_literal: true

module Lcms
  module Engine
    class MaterialForm < ImportForm
      attribute :source_type, String

      attr_reader :material

      #
      # Options can be the following:
      #  - dpi
      #  - import_retry
      #
      # @param [Hash] attributes
      # @param [Hash] options
      #
      def initialize(attributes = {}, options = {})
        super
      end

      #
      # @return [Boolean]
      #
      def perform_save
        params = {
          dpi: options[:dpi],
          import_retry: options[:import_retry],
          source_type: source_type.presence
        }.compact
        service = MaterialBuildService.new google_credentials, params
        @material = service.build link
        @service_errors = service.errors

        material.update preview_links: {}

        true
      end
    end
  end
end
