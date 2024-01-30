# frozen_string_literal: true

module Lcms
  module Engine
    module Flashable
      extend ActiveSupport::Concern

      # Stores a flash message in Redis, if configured,
      # or logs an error message and returns an alternative
      # message if Redis is not configured.
      #
      # If the original message length is less than the
      # maximum character limit, returns the original message.
      #
      # @param [String] original_message The original flash message string
      # @return [String] Either the original message or the key to retrieve the stored message from Redis
      #
      def store_flash_message(original_message)
        return original_message if original_message.length < Lcms::Engine::FLASH_MESSAGE_MAX_CHAR

        redis = Rails.application.config.redis
        if redis.present?
          key = "#{Lcms::Engine::FLASH_REDIS_PREFIX}#{SecureRandom.hex}"
          redis.set(key, original_message)
          redis.expire(key, 1.hour)
          key
        else
          Rails.logger.error 'Preview error: Redis is not configured'
          Rails.logger.error "Preview error: #{original_message}"
          'Error is too long to be displayed. Please check the logs.'
        end
      end
    end
  end
end
