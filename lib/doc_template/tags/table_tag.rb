# frozen_string_literal: true

module DocTemplate
  module Tags
    class TableTag < BaseTag
      def parse(node, opts = {})
        unless (table = node.ancestors('table').first)
          raise DocumentError, "Tag #{self.class::TAG_NAME.upcase} placed outside table"
        end

        @opts = opts
        parse_table table

        self
      end

      def parse_table(_table)
        raise NotImplementedError
      end
    end
  end
end
