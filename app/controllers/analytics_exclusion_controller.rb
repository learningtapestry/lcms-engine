# frozen_string_literal: true

class AnalyticsExclusionController < ApplicationController
  def exclude
    render layout: false,
           locals: {
             ga_id: ENV['GOOGLE_ANALYTICS_ID']
           }
  end
end
