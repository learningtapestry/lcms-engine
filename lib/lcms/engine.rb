# frozen_string_literal: true

module Lcms
  module Engine
    # TODO: Set the correct prefix after renaming all the tables?
    def self.table_name_prefix
      ''
    end
  end
end

require 'lcms/engine/engine'
require 'lcms/engine/migration'
