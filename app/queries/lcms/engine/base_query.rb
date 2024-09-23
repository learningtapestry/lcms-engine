# frozen_string_literal: true

module Lcms
  module Engine
    class BaseQuery
      def self.call(query, pagination = nil)
        new(query, pagination).call
      end

      # query : query params (Hash or OpenStruct)
      # pagination : pagination params, if pagination is nil whe return all results
      def initialize(query, pagination = nil)
        # query is a type of `Struct` with pre-defined and pre-populated fields
        @q = query
        @pagination = pagination
      end

      # Returns: ActiveRecord relation
      def call
        raise NotImplementedError
      end

      private

      attr_reader :q
    end
  end
end
