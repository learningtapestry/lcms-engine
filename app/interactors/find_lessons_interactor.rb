# frozen_string_literal: true

class FindLessonsInteractor < BaseInteractor
  attr_reader :props

  def run
    @props = pagination.serialize(lessons, serializer).merge(filterbar.props)
  end

  private

  def filterbar
    @filterbar ||= Filterbar.new(params)
  end

  def pagination
    @pagination ||= Pagination.new(params)
  end

  def search?
    filterbar.search_term.present?
  end

  def serializer
    search? ? SearchResourceSerializer : ResourceSerializer
  end

  def lessons
    if search?
      Search::Document
        .search(filterbar.search_term, filterbar.search_params.merge(doc_type: :lesson))
        .paginate(pagination.params)

    else
      Resource.tree.lessons
        .where_subject(filterbar.subjects)
        .where_grade(filterbar.grades)
        .paginate(pagination.params(strict: true))
        .ordered
    end
  end
end
