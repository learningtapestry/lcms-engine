# frozen_string_literal: true

module Lcms
  module Engine
    class << self
      # TODO: Set the correct prefix after renaming all the tables?
      def table_name_prefix
        ''
      end

      def webpacker
        @webpacker ||=
          begin
            root_path = Pathname.new File.expand_path('../..', __dir__)
            ::Webpacker::Instance.new(
              root_path: root_path,
              config_path: root_path.join('config/webpacker.yml')
            )
          end
      end
    end
  end
end

require 'lcms/engine/engine'
require 'lcms/engine/migration'
