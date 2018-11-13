# frozen_string_literal: true

module DocTemplate
  module Tags
    class CalloutTag < TableTag
      TAG_NAME = 'callout'
      TEMPLATES = {
        default: 'callout.html.erb',
        gdoc: 'gdoc/callout.html.erb'
      }.freeze

      def parse_table(table)
        header, content = fetch_content(table)
        params = {
          content: content,
          header: header,
          subject: @opts[:metadata].resource_subject
        }
        new_content = parse_template params, template_name(@opts)

        @opts[:parent_node] = new_content
        parsed_content = parse_nested new_content, @opts

        # Place placeholder where it should be
        before_tag(previous_non_empty(table) || table)

        # returns the generated content to be stored as part
        @content = parsed_content
        table.remove
      end

      private

      def fetch_content(node)
        [node.at_xpath('.//tr[2]/td').try(:content) || '',
         node.at_xpath('.//tr[3]/td').try(:inner_html) || '']
      end

      def previous_non_empty(node)
        while (node = node.previous_sibling)
          break unless node.content.squish.blank?
        end
        node
      end
    end

    Template.register_tag(Tags::CalloutTag::TAG_NAME, CalloutTag)
  end
end
