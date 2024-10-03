# frozen_string_literal: true

module Lcms
  module Engine
    module Filterable
      extend ActiveSupport::Concern

      included do
        scope :where_grade, ->(grades) { where_metadata_in :grade, grades }
        scope :where_module, ->(modules) { where_metadata_in :module, modules }
        scope :where_subject, ->(subjects) { where_metadata_in :subject, subjects }
      end

      class_methods do
        #
        # @param [String|Symbol] key
        # @param [Array<String>|Array<Integer>] arr
        # @return [ActiveRecord::QueryMethods::WhereChain]
        #
        def where_metadata_in(key, arr)
          arr = Array.wrap(arr).compact.map(&:downcase)
          base_table =
            case name
            when 'Lcms::Engine::Material'
              'materials'
            when 'Lcms::Engine::Resource'
              'resources'
            when 'Lcms::Engine::Document'
              'documents'
            else
              raise "Unknown table name: #{name}"
            end
          clauses = Array.new(arr.count) { "lower(#{base_table}.metadata->>'#{key}') = ?" }.join(' OR ')
          where(clauses, *arr)
        end
      end
    end
  end
end
