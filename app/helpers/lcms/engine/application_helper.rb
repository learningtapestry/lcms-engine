# frozen_string_literal: true

require 'webpacker/helper'

module Lcms
  module Engine
    module ApplicationHelper
      include ViewHelper
      include ::Webpacker::Helper

      # Use this to include lcms-engine based packs
      def lcms_engine_javascript_pack_tag(*names, **options)
        entries = names
                    .map { |name| Lcms::Engine.webpacker.manifest.lookup!(name, type: :javascript) }
                    .flatten
        javascript_include_tag(*entries, **options)
      end
    end
  end
end
