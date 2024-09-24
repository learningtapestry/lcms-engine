# frozen_string_literal: true

module Lcms
  module Engine
    # Usage:
    #   @materials = AdminMaterialsQuery.call(query_params, page: params[:page])
    class AdminMaterialsQuery < BaseQuery
      STRICT_METADATA = %w(subject).freeze

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
          next unless q.respond_to?(key)
          next unless q[key].present?

          @scope =
            if key.to_s == 'grades'
              grades = Array.wrap(q.grades).reject(&:blank?)
              values = grades.map { _1[/\d+/].nil? ? _1 : _1[/\d+/] }
              values.any? ? @scope = @scope.where_grade(values) : @scope
            elsif STRICT_METADATA.include?(key.to_s)
              @scope.where_metadata(key => q[key].to_s.downcase)
            else
              @scope.where_metadata_like(key, q[key])
            end
        end
      end

      def metadata_keys
        default_keys = DocTemplate.config.dig('metadata', 'service')
                         .constantize.materials_metadata.attribute_set.map(&:name)
        # From search form comes `grades` field which can contain multiple values
        default_keys.delete('grade')
        default_keys.push('grades')
      end

      def search_by_identifier
        # we need the `with_pg_search_rank` scope for this to work with DISTINCT
        # See more on: https://github.com/Casecommons/pg_search/issues/238
        @scope = @scope.search_identifier(q.search_term).with_pg_search_rank if q.search_term.present?
      end

      def search_by_file_name
        return if q.search_file_name.blank?

        ActiveSupport::Deprecation
          .warn('Lcms::Engine::Material.search_name has been removed. Refactor your calls accordingly.')
        # @scope = @scope.search_name(q.search_file_name).with_pg_search_rank
      end

      def sorted_scope
        @scope = @scope.reorder('identifier') if q.sort_by.blank? || q.sort_by == 'identifier'
        @scope = @scope.reorder('updated_at DESC') if q.sort_by == 'last_update'
        @scope.distinct
      end
    end
  end
end
