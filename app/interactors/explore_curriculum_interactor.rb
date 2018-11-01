# frozen_string_literal: true

class ExploreCurriculumInteractor < BaseInteractor
  attr_reader :props

  def run; end

  def index_props
    slug_param ? expanded_props : grades_props
  end

  def show_props
    resource = Resource.tree.find(params[:id])
    CurriculumResourceSerializer.new(resource, depth: 1).as_json
  end

  private

  def filterbar
    @filterbar ||= Filterbar.new(params)
  end

  def grades
    @grades ||= Resource.tree.grades
                  .includes(:copyright_attributions, :resource_downloads)
                  .eager_load(:standards)
                  .where_subject(filterbar.subjects)
                  .where_grade(filterbar.grades)
                  .ordered
  end

  def grades_props
    ActiveModel::ArraySerializer.new(
      grades,
      each_serializer: CurriculumResourceSerializer,
      root: :results
    ).as_json.merge(filterbar.props)
  end

  def expanded_props
    target = Resource.tree.find_by(slug: slug_param)
    raise "Unknown Resource slug value: '#{slug_param}'" unless target

    grade = target.parents.detect(&:grade?)
    depth = Resource::HIERARCHY.index(target.curriculum_type.to_sym)

    # self and ancestors, except the subject
    active_branch = target.self_and_ancestors.reject(&:subject?).map(&:id).reverse

    if expanded?
      depth += 1
      first_child = target.children.first
      active_branch << first_child.id if first_child.present?
    end

    {
      active: active_branch,
      expanded: expanded? ? true : nil,
      results: grades.map do |curr|
        CurriculumResourceSerializer.new(
          curr,
          depth: curr.id == grade.try(:id) ? depth : 0,
          depth_branch: active_branch
        ).as_json
      end
    }.compact.merge(filterbar.props)
  end

  def slug_param
    slug = params[:p]
    (slug.start_with?('/') ? slug[1..-1] : slug) if slug.present?
  end

  def expanded?
    params[:e].present?
  end
end
