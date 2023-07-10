# frozen_string_literal: true

module Lcms
  module Engine
    module Filterable
      extend ActiveSupport::Concern

      included do
        scope :where_grade, ->(grades) { where_metadata_in :grade, grades }
        scope :where_module, ->(modules) { where_metadata_in :module, modules }
        scope :where_subject, ->(subjects) { where_metadata_in :subject, subjects }

        #
        # @param [String|Symbol] key
        # @param [Array<String>|Array<Integer>] arr
        # @return [ActiveRecord::QueryMethods::WhereChain]
        #
        def self.where_metadata_in(key, arr)
          arr = Array.wrap(arr)
          clauses = Array.new(arr.count) { "#{self.table_name}.metadata->>'#{key}' = ?" }.join(' OR ')
          where(clauses, *arr)
        end
      end
    end
  end
end
