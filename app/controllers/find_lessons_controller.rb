# frozen_string_literal: true

class FindLessonsController < ApplicationController
  def index
    @props = FindLessonsInteractor.call(self).props
    respond_to do |format|
      format.html
      format.json { render json: @props }
    end
  end
end
