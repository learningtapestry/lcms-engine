# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentForm < ImportForm
      attr_reader :document

      #
      # Options can be the following:
      #  - auto_gdoc_generation
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
        @document = build_document
        @document.update(reimported: true)
        after_reimport_hook
        true
      end

      private

      attr_reader :options

      def after_reimport_hook
        DocumentGenerator.generate_for(@document) \
          if ActiveRecord::Type::Boolean.new.cast(options[:auto_gdoc_generation])
      end

      def build_document
        service = document_build_service
        result = service.build_for(link)
        @service_errors = service.errors
        result
      end

      def document_build_service
        DocumentBuildService.new(google_credentials, import_retry: options[:import_retry])
      end

      def file_id
        ::Lt::Lcms::Lesson::Downloader::Base.file_id_for link
      end
    end
  end
end
