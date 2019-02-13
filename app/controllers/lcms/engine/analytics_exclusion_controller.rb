# frozen_string_literal: true

module Lcms
  module Engine
    class AnalyticsExclusionController < Lcms::Engine::ApplicationController
      def exclude
        render layout: false,
               locals: {
                 ga_id: ENV['GOOGLE_ANALYTICS_ID']
               }
      end
    end
  end
end
