# frozen_string_literal: true

module Lcms
  module Engine
    module RSpec
      module ControllerRoutes
        extend ActiveSupport::Concern

        included do
          routes { ::Lcms::Engine::Engine.routes }
        end
      end
    end
  end
end

RSpec.configure do |c|
  c.include Lcms::Engine::RSpec::ControllerRoutes, type: :controller
end
