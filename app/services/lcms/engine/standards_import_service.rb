# frozen_string_literal: true

require 'csv'

module Lcms
  module Engine
    class StandardsImportService < ImportService
      class << self
        #
        # @param [String] url
        #
        def call(url)
          ActiveRecord::Base.transaction do
            Lcms::Engine::Standard.destroy_all
            CSV.parse(super, headers: true, &method(:create_from_csv_row))
          end
          after_reimport_hook
        end

        def after_reimport_hook; end

        private

        #
        # @param [Array<String>]
        #
        def create_from_csv_row(_row)
          raise NotImplementedError
        end
      end
    end
  end
end
