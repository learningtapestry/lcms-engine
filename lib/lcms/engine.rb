# frozen_string_literal: true

module Lcms
  module Engine
    class << self
      # TODO: Set the correct prefix after renaming all the tables?
      def table_name_prefix
        ''
      end
    end
  end
end

require 'lcms/engine/engine'
