# frozen_string_literal: true

module DocTemplate
  module Tags
    class LanguageArtsObjectivesTag < BlockTag
      TAG_NAME = 'language arts objectives'
      TEMPLATE = 'language_arts_objectives.html.erb'

      def parse(node, opts = {})
        nodes = block_nodes node
        nodes.each(&:remove)

        params = {
          content: parse_nested(nodes.map(&:to_html).join, opts)
        }
        @content = parse_template params, TEMPLATE
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::LanguageArtsObjectivesTag::TAG_NAME, Tags::LanguageArtsObjectivesTag)
end
