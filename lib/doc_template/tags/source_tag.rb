# frozen_string_literal: true

module DocTemplate
  module Tags
    class SourceTag < BaseTag
      TAG_NAME = 'source'
      TEMPLATE = 'source.html.erb'

      def parse(node, opts = {})
        # we have to collect all the next siblings until next activity-metadata
        content = content_until_break node
        content = parse_nested content.to_s, opts
        @content = parse_template content, TEMPLATE

        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::SourceTag::TAG_NAME, Tags::SourceTag)
end
