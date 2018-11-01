# frozen_string_literal: true

class EnhanceInstructionInteractor < BaseInteractor
  TAB_INDEX = %i(instructions videos generic).freeze

  attr_reader :props

  def run
    @props = pagination.serialize(data, serializer)
    @props.merge!(filterbar.props)
    @props.merge!(tab: active_tab)
  end

  private

  def filterbar
    @filterbar ||= Filterbar.new(params)
  end

  def pagination
    @pagination ||= Pagination.new(params)
  end

  def active_tab
    @active_tab ||= (params[:tab] || 0).to_i
  end

  def tab(name)
    TAB_INDEX.index(name)
  end

  def data
    case active_tab
    when tab(:videos) then resources(:media)
    else resources(:generic_resources)
    end
  end

  def serializer
    ResourceInstructionSerializer
  end

  def resources(type)
    scope = Resource
              .send(type)
              .where_subject(filterbar.subjects)
              .where_grade(filterbar.grades)

    scope = if type == :media
              scope.order(created_at: :desc)
            else
              scope.ordered
            end

    scope.paginate(pagination.params(strict: true))
  end
end
