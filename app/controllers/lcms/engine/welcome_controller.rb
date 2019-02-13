# frozen_string_literal: true

module Lcms
  module Engine
    class WelcomeController < Lcms::Engine::ApplicationController
      def index
        redirect_to root_path
      end
    end
  end
end
