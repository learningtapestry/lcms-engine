# frozen_string_literal: true

module Lcms
  module Engine
    class FindLessonsController < Lcms::Engine::ApplicationController
      def index
        @props = FindLessonsInteractor.call(self).props
        respond_to do |format|
          format.html
          format.json { render json: @props }
        end
      end
    end
  end
end
