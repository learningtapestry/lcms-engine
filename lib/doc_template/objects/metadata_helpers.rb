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

      def standard_info(standards)
        Array.wrap(standards)
          .flat_map { |x| x.to_s.split(SEPARATOR) }
          .map(&:strip)
          .reject(&:blank?)
          .uniq
          .map { |x| { description: Standard.search_by_name(x).take&.description, standard: x } }
      end
    end
  end
end
