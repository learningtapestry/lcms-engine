# frozen_string_literal: true

module Lcms
  module Engine
    # Usage:
    #   @documents = AdminDocumentsQuery.call(query_params, page: params[:page])
    #
    class AdminDocumentsQuery < BaseQuery
      # Returns: ActiveRecord relation
      def call
        @scope = Document.all # initial scope
        @scope = apply_filters

        if @pagination.present?
          sorted_scope.paginate(page: @pagination[:page])
        else
          sorted_scope
        end
      end

      private

      def apply_filters # rubocop:disable Metrics/AbcSize
        @scope = q.inactive == '1' ? @scope.unscoped : @scope.actives
        @scope = @scope.failed if q.only_failed == '1'
        @scope = @scope.filter_by_term(q.search_term) if q.search_term.present?
        @scope = @scope.filter_by_subject(q.subject) if q.subject.present?
        @scope = @scope.filter_by_grade(q.grade) if q.grade.present?
        @scope = @scope.where_grade(q.grades&.compact) if Array.wrap(q.grades).reject(&:blank?).present?
        @scope = @scope.filter_by_module(q.module) if q.module.present?
        @scope = @scope.filter_by_unit(q.unit) if q.unit.present?
        @scope = @scope.with_broken_materials if q.broken_materials == '1'
        @scope = @scope.with_updated_materials if q.reimport_required == '1'
        @scope
      end

      def sorted_scope
        @scope = @scope.order_by_curriculum if q.sort_by.blank? || q.sort_by == 'curriculum'
        @scope = @scope.order(updated_at: :desc) if q.sort_by == 'last_update'
        @scope.distinct.order(active: :desc)
      end
    end
  end
end
