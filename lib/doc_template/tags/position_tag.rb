# frozen_string_literal: true

module DocTemplate
  module Tags
    class PositionTag < TableTag
      TAG_NAME = 'position'
      TEMPLATE = 'position.html.erb'

      def parse_table(table)
        table.remove && return unless @opts[:parent_tags].try(:include?, Tags::MaterialsTag::TAG_NAME)

        params = {
          content: table.at_xpath('.//tr[2]/td').inner_html,
          position: @opts[:value].strip
        }

        content = parse_template params, TEMPLATE
        @content = parse_nested(content, @opts)
        replace_tag table
      end
    end
  end

  # TODO: Currently will work only inside materials tag
  Template.register_tag(Tags::PositionTag::TAG_NAME, Tags::PositionTag)
end
