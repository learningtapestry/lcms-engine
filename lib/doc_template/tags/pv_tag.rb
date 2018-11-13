# frozen_string_literal: true

module DocTemplate
  module Tags
    class PvTag < BaseTag
      TAG_NAME = 'pv'
      TEMPLATE = 'pv.html.erb'

      def parse(node, opts = {})
        config = Tags.config[TAG_NAME.downcase]
        if config && (data = config[opts[:value].to_s.downcase]).present?
          @content = parse_template data, TEMPLATE
          replace_tag node
        else
          node.remove
        end

        self
      end
    end

    Template.register_tag(Tags::PvTag::TAG_NAME, PvTag)
  end
end
