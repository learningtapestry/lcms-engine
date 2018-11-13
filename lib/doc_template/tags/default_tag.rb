# frozen_string_literal: true

module DocTemplate
  module Tags
    class DefaultTag < BaseTag
      TAG_NAME = 'default'

      def parse(node, _options = {})
        return super if DocTemplate::Tags.config.dig('default', 'remove')

        node['data-parsed'] = true
        @result = node
        self
      end
    end
  end

  Template.register_tag(Tags::DefaultTag::TAG_NAME, Tags::DefaultTag)
end
