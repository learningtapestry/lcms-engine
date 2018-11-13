# frozen_string_literal: true

module DocTemplate
  module Tags
    class MaterialsTag < BaseTag
      TAG_NAME = 'materials'
      TEMPLATE = 'materials.html.erb'

      def parse(node, _opts = {})
        # we have to collect all the next siblings until next activity-metadata
        content_until_break(node)
        node.remove
        self
      end
    end
  end

  Template.register_tag(Tags::MaterialsTag::TAG_NAME, Tags::MaterialsTag)
end
