# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceSerializer < ActiveModel::Serializer
      include ResourceHelper

      attributes :breadcrumb_title, :grade, :id, :is_assessment, :is_foundational, :is_opr, :is_prerequisite, :path,
                 :short_title, :subject, :teaser, :time_to_teach, :title, :type

      def breadcrumb_title
        Breadcrumbs.new(object).title
      end

      def grade
        object.grades.average
      end

      def is_assessment # rubocop:disable Naming/PredicateName
        object&.assessment? || short_title&.index('assessment').present?
      end

      def is_foundational # rubocop:disable Naming/PredicateName
        object.document&.foundational?
      end

      def is_opr # rubocop:disable Naming/PredicateName
        object.opr?
      end

      def is_prerequisite # rubocop:disable Naming/PredicateName
        object.prerequisite?
      end

      def path
        return document_path(object.document) if object.document? && !object.assessment?

        show_resource_path(object)
      end

      def type
        object.curriculum_type
      end
    end
  end
end
