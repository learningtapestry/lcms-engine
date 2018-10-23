# frozen_string_literal: true

module Lcms
  module Engine
    # Main application controller
    class ApplicationController < ActionController::Base
      protect_from_forgery with: :exception
    end
  end
end
