# frozen_string_literal: true

# This is a subset of the previous ResourceSerializer, meant to be used on listings
# like find_lessons and search cards. We use this instead the full version (ResourceDetailsSerializer)
# to avoid expensive queries on data we don't need (like downloads, and related)
class ResourceSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false

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
