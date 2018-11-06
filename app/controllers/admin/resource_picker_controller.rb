# frozen_string_literal: true

module Admin
  class ResourcePickerController < AdminController
    def index
      @resources = Resource.where(nil)

      @resources = @resources.where_subject(index_params[:subject]) if index_params[:subject].present?
      @resources = @resources.where(curriculum_type: index_params[:type]) if index_params[:type].present?
      @resources = @resources.where_grade(grade_name) if index_params[:grade].present?
      @resources = @resources.where('title ilike ?', "%#{params[:q]}%") if index_params[:q].present?

      @resources = @resources.paginate(pagination.params(strict: true)).order('resources.title asc')

      respond_to do |format|
        format.json { render json: pagination.serialize(@resources, ResourcePickerSerializer) }
      end
    end

    private

    def index_params
      @index_params ||= begin
        default_params = { type: nil, subject: nil, grade: nil, q: nil }
        expected_params = params.slice(:type, :subject, :grade, :q).symbolize_keys
        index_p = default_params.merge(expected_params)

        grade_ok = index_p[:grade].blank? || Filterbar::GRADES.include?(index_p[:grade])
        type_ok = index_p[:type].blank? || Resource::HIERARCHY.include?(index_p[:type].to_sym)
        subject_ok = index_p[:subject].blank? || Resource::SUBJECTS.include?(index_p[:subject])

        raise StandardError unless grade_ok && type_ok && subject_ok

        index_p
      end
    end

    def pagination
      @pagination ||= Pagination.new(params)
    end

    def grade_name
      if index_params[:grade].casecmp('K').zero?
        'kindergarten'
      elsif index_params[:grade].casecmp('PK').zero?
        'prekindergarten'
      elsif !index_params[:grade].start_with?('grade')
        "grade #{index_params[:grade]}"
      else
        index_params[:grade]
      end
    end
  end
end
