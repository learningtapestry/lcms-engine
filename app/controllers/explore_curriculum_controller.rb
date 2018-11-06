# frozen_string_literal: true

class ExploreCurriculumController < ApplicationController
  def index
    @props = interactor.index_props
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end

  def show
    @props = interactor.show_props
    respond_to do |format|
      format.json { render json: @props }
    end
  end

  private

  def interactor
    ExploreCurriculumInteractor.call(self)
  end
end
