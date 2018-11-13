# frozen_string_literal: true

module DocTemplate
  module Tags
    class OptBreakTag < BaseTag
      TAG_NAME = 'optbreak'
      TEMPLATES = { default: 'opt_break.html.erb',
                    gdoc: 'gdoc/opt_break.html.erb' }.freeze

      def parse(node, opts = {})
        content = content_until_break node
        parsed_template = parse_template content, template_name(opts)
        @content = parse_nested parsed_template, opts

        replace_tag node

        # add break to agenda
        opts[:agenda].add_break
        self
      end
    end

    Template.register_tag(Tags::OptBreakTag::TAG_NAME, OptBreakTag)
  end
end
