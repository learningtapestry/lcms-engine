# frozen_string_literal: true

class CurriculumMap
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def props
    return {} unless resource.present?

    { active: active_branch, results: curriculum }
  end

  private

  def full_depth?
    @full_depth ||= resource.lesson? || resource.unit? || resource.module?
  end

  def active_branch
    @active_branch ||= resource.self_and_ancestor_ids
  end

  def target_branch
    if full_depth?
      mod = resource.parents.detect(&:module?)
      mod ? mod.children.ids : []
    else
      []
    end
  end

  def curriculum
    grade = resource.ancestors
              .includes(:copyright_attributions)
              .eager_load(:standards)
              .where(curriculum_type: :grade)
              .take
    CurriculumResourceSerializer.new(
      grade,
      depth: full_depth? ? Resource::HIERARCHY.size : 1,
      depth_branch: active_branch + target_branch
    ).as_json
  end
end
