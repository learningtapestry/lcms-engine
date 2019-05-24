# frozen_string_literal: true

# TODO: Move to lt-lcms gem
module Lt
  module Lcms
    module Metadata
      class BaseService
        class << self
          attr_reader :activity_metadata, :metadata, :section_metadata

          def materials_metadata
            raise NotImplementedError
          end

          def options_for(context)
            raise 'Metadata is empty' unless metadata.present?

            {}.tap do |result|
              result.merge!(lesson_options) unless material?
              result.merge(context_type: context)
            end
          end

          def parse(_content, *args)
            @options = args.extract_options!
          end

          protected

          attr_reader :options

          def lesson_options
            raise NotImplementedError
          end

          def material?
            options&.[](:material)
          end
        end
      end
    end
  end
end
