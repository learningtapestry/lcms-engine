# frozen_string_literal: true

class ResourceInstructionSerializer < ActiveModel::Serializer
  include ResourceHelper

  self.root = false
  attributes :id, :title, :subject, :teaser, :path, :img, :instruction_type,
             :grade_avg, :time_to_teach

  def title
    return object.title if media?

    type_name = I18n.t("resource_types.#{object.resource_type}")
    object.grades.present? ? "#{object.grades.to_str} #{type_name}" : type_name
  end

  def subject
    object.subject.try(:downcase) || 'default'
  end

  def teaser
    object.title
  end

  def path
    media? ? media_path(object.id) : generic_path(object)
  end

  def img
    object.try(:image_file).try(:url) || placeholder
  end

  def instruction_type
    media? ? object.resource_type : :generic
  end

  def grade_avg
    object.grades.average
  end

  private

  def media?
    object.media?
  end

  def placeholder
    ActionController::Base.helpers.image_path('resource_placeholder.jpg')
  end
end
