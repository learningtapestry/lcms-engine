# frozen_string_literal: true

module DocTemplate
  module Tags
    class DefTag < BaseTag
      include ERB::Util

      STYLE_RE = /<span (style=[^.>]*)>[^<]*$/i
      TAG_NAME = 'def'
      TAG_SEPARATOR = '[separator]'
      TEMPLATES = {
        default: 'def.html.erb',
        gdoc: 'gdoc/def.html.erb'
      }.freeze

      def parse(node, opts = {})
        # Need to extract the Tag and preserves all the styling inside it
        node_html = node.inner_html
        start_pos = node_html.index '['
        end_pos = node_html.rindex ']'
        needle = node_html[start_pos..end_pos]

        preserved_style = STYLE_RE.match(needle).try(:[], 1)
        subject = (opts[:metadata].try(:[], 'subject').presence || 'ela').downcase
        definition, description = opts[:value].split(';').map(&:strip)

        data = node_html.sub(needle, TAG_SEPARATOR).split(TAG_SEPARATOR, 2).map(&:squish)

        params = {
          append: data[1],
          definition: definition,
          description: description,
          prepend: data[0],
          preserved_style: preserved_style,
          subject: subject
        }

        @content = "<p>#{parse_template(params, template_name(opts))}</p>"

        if node.name == 'li'
          @result = node.replace "<li class='#{node['class']}'>#{placeholder}</li>"
        else
          replace_tag node
        end
        self
      end
    end
  end

  Template.register_tag(Tags::DefTag::TAG_NAME, Tags::DefTag)
end
