# frozen_string_literal: true

module RetryDelayed
  extend ActiveSupport::Concern

  module RetryBackoffStrategy
    MIN_DELAY_MULTIPLIER = 1.0
    MAX_DELAY_MULTIPLIER = 5.0
    RETRY_DELAYES = [30.seconds, 1.minute, 3.minutes, 7.minutes].freeze

    def self.should_retry?(retry_attempt, exception)
      return false if exception.message =~ /Script error message/ && exception.message =~ /PAGE_BREAK/
      retry_attempt <= RETRY_DELAYES.size
    end

    def self.retry_delay(retry_attempt, _exception)
      (RETRY_DELAYES[retry_attempt] || 0) * rand(MIN_DELAY_MULTIPLIER..MAX_DELAY_MULTIPLIER)
    end
  end

  included do
    include ActiveJob::Retry.new(strategy: RetryBackoffStrategy)
  end
end
