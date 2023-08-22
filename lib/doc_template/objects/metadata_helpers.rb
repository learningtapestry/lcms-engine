# frozen_string_literal: true

module DocTemplate
  module Objects
    module MetadataHelpers
      SEPARATOR = /\s*[,;]\s*/

      def self.build_anchor_from(item)
        [
          item.idx,
          'core',
          item.try(:level),
          item.title
        ].compact.join('-').parameterize
      end
    end
  end
end
