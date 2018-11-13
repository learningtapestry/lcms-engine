# frozen_string_literal: true

module DocTemplate
  module Tags
    class InsetTag < BlockTag
      STYLES_REGEXP = {
        bold: /font-weight:[6-9]00/i,
        italic: /font-style:italic/i
      }.freeze
      TAG_NAME = 'inset'

      def parse(node, opts = {})
        nodes = block_nodes(node) { |n| preserve_styles n, opts }
        content = parse_nested nodes.map(&:to_html).join, opts
        nodes.each(&:remove)
        @content =
          if gdoc?(opts)
            %(#{content}<p class="do-not-strip"></p>)
          else
            %(<div class="o-ld-inset">#{content}</div>)
          end
        replace_tag node
        self
      end

      private

      def preserve_styles(node, opts)
        add_css_class(node, 'o-ld-inset') if gdoc?(opts)
        node.children.each do |el|
          el['class'] = el['class'].to_s + ' text-bold' if el['style'] =~ STYLES_REGEXP[:bold]
          el['class'] = el['class'].to_s + ' text-italic' if el['style'] =~ STYLES_REGEXP[:italic]
        end
        node
      end

      def add_css_class(el, *classes)
        existing = (el[:class] || '').split(/\s+/)
        el[:class] = existing.concat(classes).uniq.join(' ')
      end
    end
  end

  Template.register_tag(Tags::InsetTag::TAG_NAME, Tags::InsetTag)
end
