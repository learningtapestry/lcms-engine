# frozen_string_literal: true

module DocTemplate
  module Tags
    class ColumnsTag < BlockTag
      include ERB::Util

      ALIGNMENT_RE = /^align-right\s/i
      SPLIT_SYMBOL = ';'
      TAG_NAME = 'columns'
      TEMPLATE = 'columns.html.erb'

      def parse(node, opts = {})
        @opts = opts
        @images = []
        @tags = []

        data = fetch_content node

        rows = substitute_images(data).map do |row|
          row.map do |td|
            td = substitute_tags td
            handle_alignment_for td
          end
        end

        @content = parse_template({ rows: }, TEMPLATE) if rows.any?
        replace_tag node
        self
      end

      private

      def add_tags_from(node)
        re = DocTemplate::Tags::StandardTag::TAG_RE
        return node unless (m = re.match node.inner_html)

        m.to_a.each do |tag|
          @tags << tag
          node.content = node.content.sub re, "{tag: #{@tags.size - 1}}"
        end

        node
      end

      #
      # Going down the DOM tree until the end tag. Placing own markers
      # for nested tags and images to revert them back later on
      #
      def fetch_content(node)
        nodes = block_nodes(node) do |n|
          fetch_images n
          add_tags_from n
        end

        nodes.map(&:remove)

        # Handles alignment.
        # Content team places ` r;` to make right alignment for the next column
        # Just swap position of the ` r` and `;` to simplify the alogorithm
        data = nodes
                 .map { |n| n.content.squish }
                 .join
                 .gsub(' r;', ';align-right ')

        data
          .split(SPLIT_SYMBOL)
          .map(&:strip)
          .reject(&:blank?)
          .in_groups_of(@opts[:value].to_i, '')
      end

      def fetch_images(node)
        node.xpath('.//img').each do |img|
          @images << {
            src: img['src'],
            style: img['style']
          }
          img.replace "{image: #{@images.size - 1}}"
        end
        node
      end

      def handle_alignment_for(td)
        {}.tap do |result|
          result[:content] = td.sub ALIGNMENT_RE, ''
          result[:css_class] = 'text-right' if td =~ ALIGNMENT_RE
        end
      end

      def substitute_images(data)
        re = /{image: (\d)+}/
        data.map do |row|
          row.map do |td|
            if (m = re.match td) && (img = @images[m[1].to_i]).present?
              td = td.sub re, %(<img src="#{img[:src]}" style="#{img[:style]}" />)
            end
            td
          end
        end
      end

      def substitute_tags(content)
        re = /{tag: (\d)+}/
        content.scan(re).each do |idx|
          next unless (tag = @tags[idx.first.to_i]).present?

          parsed_tag = parse_nested "<p><span>#{tag}</span></p>", @opts
          content = content.sub re, parsed_tag
        end
        content
      end
    end
  end

  Template.register_tag(Tags::ColumnsTag::TAG_NAME, Tags::ColumnsTag)
end
