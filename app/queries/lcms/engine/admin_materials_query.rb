# frozen_string_literal: true

module Lcms
  module Engine
    # Usage:
    #   @materials = AdminMaterialsQuery.call(query_params, page: params[:page])
    class AdminMaterialsQuery < BaseQuery
      # Returns: ActiveRecord relation
      def call
        @scope = Material.all # initial scope
        search_by_identifier
        search_by_file_name

        filter_by_metadata

        if @pagination.present?
          sorted_scope.paginate(page: @pagination[:page])
        else
          sorted_scope
        end
      end

      private

      def filter_by_metadata
        metadata_keys.each do |key|
          @scope = @scope.where_metadata_like(key, q[key]) if q[key].present?
        end
      end

      def metadata_keys
        DocTemplate.config.dig('metadata', 'service').constantize.materials_metadata.attribute_set.map(&:name)
      end

      def search_by_identifier
        # we need the `with_pg_search_rank` scope for this to work with DISTINCT
        # See more on: https://github.com/Casecommons/pg_search/issues/238
        @scope = @scope.search_identifier(q.search_term).with_pg_search_rank if q.search_term.present?
      end

      def search_by_file_name
        @scope = @scope.search_name(q.search_file_name).with_pg_search_rank if q.search_file_name.present?
      end

      def sorted_scope
        @scope = @scope.reorder(:identifier) if q.sort_by.blank? || q.sort_by == 'identifier'
        @scope = @scope.reorder(updated_at: :desc) if q.sort_by == 'last_update'
        @scope.distinct
      end
    end
  end
end
