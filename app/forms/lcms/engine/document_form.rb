# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentForm
      include Virtus.model
      include ActiveModel::Model
      include Lcms::Engine::GoogleCredentials

      attribute :link, String

      validates_presence_of :link

      attr_reader :document, :service_errors

      #
      # Options can be the following:
      #  - auto_gdoc_generation
      #  - import_retry
      #
      # @param [Hash] attributes
      # @param [Hash] options
      #
      def initialize(attributes = {}, options = {})
        super(attributes)
        @options = options
      end

      def save
        return false unless valid?

        @document = build_document
        after_reimport_hook
        @document.update(reimported: true)
      rescue StandardError => e
        @document&.update(reimported: false)
        Rails.logger.error "#{e.message}\n #{e.backtrace.join("\n ")}"
        errors.add(:link, e.message)
        false
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
