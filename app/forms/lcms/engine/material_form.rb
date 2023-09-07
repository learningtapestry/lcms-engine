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
      def save
        super do
          params = {
            dpi: options[:dpi],
            import_retry: options[:import_retry],
            source_type: source_type.presence
          }.compact
          service = MaterialBuildService.new(google_credentials, params)
          @material = service.build link
          @service_errors.push(*service.errors.uniq)

          material.update preview_links: {}
        end
      end

      protected

      def after_reimport_hook; end
    end
  end
end
