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
      def save
        super do
          @document = build_document
          @document.update(reimported: true)
        end
      end

      private

      def after_reimport_hook
        DocumentGenerator.generate_for(@document) \
          if ActiveRecord::Type::Boolean.new.cast(options[:auto_gdoc_generation])
      end

      def build_document
        service = DocumentBuildService.new(google_credentials, import_retry: options[:import_retry])
        result = service.build_for(link)
        @service_errors.push(*service.errors.uniq)
        result
      end

      def file_id
        ::Lt::Lcms::Lesson::Downloader::Base.file_id_for link
      end
    end
  end
end
