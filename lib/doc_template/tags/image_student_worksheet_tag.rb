# frozen_string_literal: true

module DocTemplate
  module Tags
    class ImageStudentWorksheetTag < BaseTag
      include ERB::Util

      HEIGHT_MOD = 0.85
      TAG_NAME = 'image-student-worksheet'
      TEMPLATE = 'image-student-worksheet.html.erb'

      def parse(node, _options = {})
        if (image = find_image node)
          image.ancestors('p').first.try(:remove)
          params = prepare_content image
          @content = parse_template params, TEMPLATE
          replace_tag node
        else
          node.remove
        end

        self
      end

      private

      def find_image(node)
        while (node = node.next_sibling)
          if (image = node.at_xpath('.//img')).present?
            return image
          end
        end
      end

      def prepare_content(image)
        {}.tap do |result|
          result[:src] = image['src']

          image['style'].split(';').each do |style|
            Hash[*style.strip.split(':')].each do |(k, v)|
              case k
              when 'height' then result[:height] = "#{(v.to_i * HEIGHT_MOD).floor}px"
              when 'width' then result[:width] = v.strip
              end
            end
          end
        end
      end
    end
  end

  Template.register_tag(Tags::ImageStudentWorksheetTag::TAG_NAME, Tags::ImageStudentWorksheetTag)
end
