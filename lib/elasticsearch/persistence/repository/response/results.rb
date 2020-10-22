# frozen_string_literal: true

# monkey patch ES results to handle pagination
module Elasticsearch
  module Persistence
    module Repository
      module Response # :nodoc:
        class Results
          include Enumerable

          attr_reader :repository, :response

          def initialize(repository, response, options = {})
            @repository = repository
            @response = Elasticsearch::Model::HashWrapper.new(response)
            @options = options
          end

          def method_missing(method_name, *arguments, &block) # rubocop:disable Style/MissingRespondToMissing
            results.respond_to?(method_name) ? results.__send__(method_name, *arguments, &block) : super
          end

          def respond_to?(method_name, include_private = false) # rubocop:disable Style/OptionalBooleanParameter
            results.respond_to?(method_name) || super
          end

          def total
            response['hits']['total']
          end

          def max_score
            response['hits']['max_score']
          end

          def each_with_hit(&block)
            results.zip(response['hits']['hits']).each(&block)
          end

          def map_with_hit(&block)
            results.zip(response['hits']['hits']).map(&block)
          end

          def results
            @results ||= response['hits']['hits'].map do |document|
              repository.deserialize(document.to_hash)
            end
          end

          def paginate(options)
            @pagination_attrs = {
              total_pages: (total.to_f / options[:per_page]).ceil,
              current_page: options[:page],
              per_page: options[:per_page],
              total_entries: total
            }
            self
          end

          def total_pages
            @pagination_attrs[:total_pages]
          end

          def current_page
            @pagination_attrs[:current_page]
          end

          def per_page
            @pagination_attrs[:per_page]
          end

          def total_entries
            @pagination_attrs[:total_entries]
          end
        end
      end
    end
  end
end
