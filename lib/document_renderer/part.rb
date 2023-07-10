# frozen_string_literal: true

module DocumentRenderer
  class Part
    PART_RE = /{{[^}]+}}/

    class << self
      def call(content, options)
        @excludes = options[:excludes] || []
        content.gsub(PART_RE) do |placeholder|
          next unless placeholder
          next unless (part = options[:parts_index][placeholder])
          next unless (subpart = part[:content])
          next unless should_render?(part, omit_optional: !options[:with_optional])

          call subpart.to_s, options
        end
      end

      private

      #
      # If part is optional:
      # - do not render it if optional have not been requested (not web-view)
      # - do not render it if optional part was not turned ON (is not inside excludes list)
      # If part is not optional:
      # - just ignore it if it has been turned OFF
      #
      def should_render?(part, omit_optional: true)
        if part[:optional] && omit_optional
          false unless @excludes.include?(part[:anchor])
        else
          !@excludes.include?(part[:anchor])
        end
      end
    end
  end
end
