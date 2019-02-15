# frozen_string_literal: true

module Lcms
  module Engine
    module DocumentsHelper
      def toc_time(time)
        time.zero? ? raw('&mdash;') : "#{time} mins"
      end
    end
  end
end
