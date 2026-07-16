# frozen_string_literal: true

module DocTemplate
  module Tags
    class TablePreserveAlignmentTag < BaseTag
      STYLE_RE = /text-align:(left|center|right)/i
      TAG_NAME = 'table-preserve-alignment'

      def parse(node, _options = {})
        if (table = find_table node)
          # inside cells for each `p` with `text-align` css param we add specific class
          table.xpath('.//p').each do |el|
            if (m = STYLE_RE.match el['style'])
              el['style'] = el['style'].sub STYLE_RE, ''
              el['class'] = "text-#{m[1]}"
            end
          end

          @content = table.to_s
          replace_tag table
        end

        node.remove

        self
      end

      private

      def find_table(node)
        while (node = node.next_sibling)
          return node if node.name.casecmp('table').zero?
        end
      end
    end

    Template.register_tag(Tags::TablePreserveAlignmentTag::TAG_NAME, TablePreserveAlignmentTag)
  end
end
