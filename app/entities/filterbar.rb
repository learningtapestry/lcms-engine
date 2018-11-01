# frozen_string_literal: true

class Filterbar
  attr_reader :params

  GRADES = %w(pk k 1 2 3 4 5 6 7 8 9 10 11 12).freeze
  FACETS = %w(grade module unit lesson multimedia other).freeze

  def initialize(params)
    @params = params
  end

  def grades
    @grades ||= begin
      names = untranslated_grades

      names.map! do |name|
        name = name.to_s
        if name.casecmp('K').zero?
          name = 'kindergarten'
        elsif name.casecmp('PK').zero?
          name = 'prekindergarten'
        elsif !name.start_with?('grade')
          name = "grade #{name}"
        end
        name
      end

      names
    end
  end

  def subjects
    @subjects ||= split(params[:subjects]) & Resource::SUBJECTS
  end

  def facets
    @facets ||= split(params[:facets]) & FACETS
  end

  def search_term
    @search_term ||= params[:search_term].presence
  end

  def search_params
    options = pagination.params(strict: true)

    # handle filters
    options[:doc_type] = search_facets if facets.present?
    options[:subject] = subjects.first if subjects.present?
    options[:grade] = grades if grades.present?

    options
  end

  def search_facets
    search_facets = facets
    search_facets.push('video', 'podcast') if search_facets.delete('multimedia')
    search_facets.push('text_set', 'quick_reference_guide') if search_facets.delete('other')
    search_facets
  end

  # props used for building the Filterbar React component
  def props
    {
      filterbar: {
        subjects: subjects,
        grades: untranslated_grades,
        facets: facets,
        search_term: search_term
      }
    }
  end

  private

  def untranslated_grades
    @untranslated_grades ||= split(params[:grades]) & GRADES
  end

  def split(ps)
    return [] if ps.blank?
    return ps if ps.is_a?(Array)

    ps.gsub(/\s+/, '').split(',')
  end

  def pagination
    @pagination ||= Pagination.new(params)
  end
end
