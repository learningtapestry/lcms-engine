# frozen_string_literal: true

class HierarchicalPosition
  RESOURCE_TYPE_ORDER = %w(resource media quick_reference_guide text_set).freeze

  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  # Position mask:
  # - We use 7 blocks of 2 numbers for:
  #     subject, resource_types, grades (average if more than one), module, unit,
  #     lesson, num_of_grades
  # - The last position is the number of different grades covered, i.e:
  #   a resource with 3 different grades show after one with 2, (more specific
  #   at the top, more generic at the bottom)
  def position
    return default_position if dettached_resource?

    [
      subject_position, # subject
      resource_type_position, # resource_type
      resource.grades.average_number, # grades
      module_position, # module
      unit_position, # unit
      lesson_position, # lesson
      resource.grades.list.size # number of grades
    ].map { |v| v.to_s.rjust(2, '0') }.join(' ')
  end

  private

  def dettached_resource?
    resource.resource? && !resource.tree?
  end

  def default_position
    @default_position ||= Array.new(7, '99').join(' ')
  end

  def subject_position
    return 99 if resource.generic?

    val = Resource::SUBJECTS.index(resource.subject)
    val ? val + 1 : 99
  end

  def resource_type_position
    type = resource.media? ? 'media' : resource.resource_type
    RESOURCE_TYPE_ORDER.index(type)
  end

  def module_position
    position_for :module?
  end

  def unit_position
    position_for :unit?
  end

  def position_for(type)
    val = if !resource.persisted? && resource.send(type)
            resource.level_position
          else
            resource.self_and_ancestors.detect { |res| res.send type }&.level_position
          end
    val ? val + 1 : 0
  end

  def lesson_position
    val =  resource.lesson? ? resource.level_position : nil
    return val if val

    lesson = resource.metadata['lesson']
    lesson =~ lesson.try(:match, /(\d+)/).try(:[], 1).to_i
  end
end
