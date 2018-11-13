# frozen_string_literal: true

module DocTemplate
  module Tags
    class SmpTag < BlockTag
      TAG_NAME = 'smp'
      TEMPLATES = { default: 'smp.html.erb',
                    gdoc: 'gdoc/smp.html.erb' }.freeze

      def parse(node, opts = {})
        nodes = block_nodes node
        nodes.each(&:remove)

        params = {
          content: parse_nested(nodes.map(&:to_html).join, opts),
          smp: opts[:value].split(';').map(&:strip)
        }
        @content = parse_template(params, template_name(opts))
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::SmpTag::TAG_NAME, Tags::SmpTag)
end
