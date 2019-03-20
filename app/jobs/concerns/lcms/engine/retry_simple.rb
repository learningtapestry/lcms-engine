# frozen_string_literal: true

require 'activejob/retry'

module Lcms
  module Engine
    module RetrySimple
      extend ActiveSupport::Concern

      included do
        include ActiveJob::Retry.new(strategy: :constant, limit: 3)
      end
    end
  end
end
