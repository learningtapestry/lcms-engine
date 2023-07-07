# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceSerializer < ActiveModel::Serializer
      include ResourceHelper

      attributes :breadcrumb_title, :grade, :id, :path, :short_title, :subject, :teaser, :time_to_teach, :title, :type

      def breadcrumb_title
        Breadcrumbs.new(object).title
      end

      def grade
        object.grades.average
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
