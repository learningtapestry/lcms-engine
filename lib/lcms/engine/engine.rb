# frozen_string_literal: true

module Lcms
  module Engine
    # Top level engine class
    class Engine < ::Rails::Engine
      isolate_namespace Lcms::Engine
    end
  end
end
