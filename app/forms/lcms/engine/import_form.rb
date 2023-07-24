# frozen_string_literal: true

module Lcms
  module Engine
    class ImportForm
      include Virtus.model
      include ActiveModel::Model
      include Lcms::Engine::GoogleCredentials

      attribute :link, String

      validates_presence_of :link

      attr_reader :service_errors

      #
      # @param [Hash|ActionController::Parameters] attributes
      # @param [Hash] options
      #
      def initialize(attributes = {}, options = {})
        super(attributes)
        @options = options
      end

      #
      # @return [Boolean]
      #
      def save
        return false unless valid?

        yield

        after_reimport_hook

        true
      rescue StandardError => e
        Rails.logger.error "#{e.message}\n #{e.backtrace.join("\n ")}"
        errors.add(:link, e.message)
        false
      end

      private

      attr_reader :options

      protected

      def after_reimport_hook; end
    end
  end
end
