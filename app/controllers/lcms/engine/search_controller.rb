# frozen_string_literal: true

module Lcms
  module Engine
    class SearchController < Lcms::Engine::ApplicationController
      def index
        @props = SearchInteractor.call(self).props
        respond_to do |format|
          format.html
          format.json { render json: @props }
        end
      end
    end
  end
end

