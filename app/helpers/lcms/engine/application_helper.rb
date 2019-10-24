# frozen_string_literal: true

require 'webpacker/helper'

module Lcms
  module Engine
    module ApplicationHelper
      include ViewHelper
      include ::Webpacker::Helper

      def current_webpacker_instance
        Lcms::Engine.webpacker
      end
    end
  end
end
