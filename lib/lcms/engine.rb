# frozen_string_literal: true

module Lcms
  module Engine
    # Maximum allowed characters for a flash message.
    # If a message exceeds this limit, it should be handled appropriately.
    FLASH_MESSAGE_MAX_CHAR = 2048

    # Prefix used when storing flash messages in Redis. This helps in identifying
    # eys related to flash messages in the Redis store.
    FLASH_REDIS_PREFIX = 'flash_key:'

    # Returns the table name prefix for the current module or class.
    #
    # @return [String] The table name prefix.
    def self.table_name_prefix
      # TODO: Set the correct prefix after renaming all the tables?
      ''
    end
  end
end

require 'lcms/engine/engine'
