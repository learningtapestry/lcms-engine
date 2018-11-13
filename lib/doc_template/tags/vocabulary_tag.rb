# frozen_string_literal: true

module DocTemplate
  module Tags
    class VocabularyTag < TableTag
      TAG_NAME = 'vocabulary'
      TEMPLATE = 'vocabulary.html.erb'

      def parse_table(table)
        params = { sections: fetch_content(table) }
        parsed_content = parse_template params, TEMPLATE
        @content = parse_nested parsed_content, @opts
        replace_tag table
      end

      private

      def fetch_content(node)
        [].tap do |result|
          # omit the first row
          cur_section = nil
          node.xpath('.//tr[position() > 1]').each do |tr|
            if (td_header = tr.at_xpath "./td[@colspan = '2']")
              result << cur_section if cur_section.present?
              cur_section = { title: td_header.text }
            elsif cur_section.present?
              cur_section[:words] ||= []
              cur_section[:words] << { name: tr.at_xpath('./td[1]').text, definition: tr.at_xpath('./td[2]').text }
            end
          end
          result << cur_section
        end
      end
    end
  end

  Template.register_tag(Tags::VocabularyTag::TAG_NAME, Tags::VocabularyTag)
end
