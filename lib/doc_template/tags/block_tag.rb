# frozen_string_literal: true

module DocTemplate
  module Tags
    class BlockTag < BaseTag
      END_VALUE = 'end'

      def no_end_tag_for(node)
        msg = "No tag with END value for: #{self.class::TAG_NAME.upcase}<br>" \
              "<em>#{node.parent.try(:inner_html)}</em>"
        raise Lcms::Engine::DocumentError, msg
      end

      #
      # Collects all the nodes before the closing tag
      #
      def block_nodes(node)
        end_tag_found = false
        tag_node = node

        # we have to collect all nodes until the we find the end tag
        nodes = [].tap do |result|
          check_tag_soft_return(node)
          while (node = node.next_sibling)
            if node.content.match?(end_tag_re)
              end_tag_found = true
              check_tag_soft_return(node)
              node.remove
              break
            end
            node = yield(node) if block_given?
            result << node
          end
        end

        no_end_tag_for(tag_node) unless end_tag_found

        nodes
      end

      private

      def end_tag_re
        @end_tag_re ||= /\[#{self.class::TAG_NAME}:\s*#{END_VALUE}\]/i
      end
    end
  end
end
