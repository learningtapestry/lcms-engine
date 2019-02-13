# frozen_string_literal: true

module Lcms
  module Engine
    class ExploreCurriculumController < Lcms::Engine::ApplicationController
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
  end
end
