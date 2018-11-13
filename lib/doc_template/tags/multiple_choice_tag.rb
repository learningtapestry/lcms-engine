# frozen_string_literal: true

module DocTemplate
  module Tags
    class MultipleChoiceTag < BlockTag
      TAG_NAME = 'multiple-choice'

      def parse(node, opts = {})
        nodes = block_nodes node
        nodes.each(&:remove)

        content = parse_nested nodes.map(&:to_html).join, opts
        @content = %(<div class="o-ld-multiple-choice">#{content}</div>)

        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::MultipleChoiceTag::TAG_NAME, Tags::MultipleChoiceTag)
end
