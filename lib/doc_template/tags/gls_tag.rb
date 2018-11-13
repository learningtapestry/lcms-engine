# frozen_string_literal: true

module DocTemplate
  module Tags
    class GlsTag < BaseTag
      TAG_NAME = 'gls'
      TEMPLATE = 'gls.html.erb'

      def parse(node, opts = {})
        parsed_content = parse_template({ content: opts[:value] }, TEMPLATE)
        node.inner_html = node.inner_html.sub DocTemplate::FULL_TAG, parsed_content
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::GlsTag::TAG_NAME, Tags::GlsTag)
end
