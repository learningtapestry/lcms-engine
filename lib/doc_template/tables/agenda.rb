# frozen_string_literal: true

module DocTemplate
  module Tables
    class Agenda < Base
      HEADER_LABEL = '[agenda]'
      ICONS_KEY = 'icon'
      MATERIALS_KEY = 'materials'
      METADATA_HEADER_LABEL = 'metadata'
      GENERAL_TAG = 'general'

      def parse(fragment, _template_type)
        xpath = "table[.//*[case_insensitive_contains(text(), '#{HEADER_LABEL}')]]"
        table = fragment.at_xpath(xpath, XpathFunctions.new)
        return self unless table

        # retain new lines
        table.search('br').each { |br| br.replace("\n") }
        @data = []

        # skip the header
        table.xpath('./*/tr[position() > 1]').each_with_index do |tr, index|
          # take the only two fields
          metadata, metacognition = tr.xpath('./td')

          # identify the referencing tag
          next unless metadata.content.present?

          tag_name, tag_value = DocTemplate::FULL_TAG.match(metadata.content).try(:captures)

          element = {
            id: tag_value.parameterize,
            title: tag_value.gsub(/^\p{Space}*/, ''),
            metadata: parse_metadata(metadata),
            metacognition: parse_metacognition(metacognition),
            children: []
          }

          # the group tags are parents and the following
          # sections after each group are children of that group
          if tag_name.downcase.include?('group')
            @data << element
          elsif index.zero?
            @data << { id: GENERAL_TAG, title: GENERAL_TAG.humanize, metadata: {}, metacognition: {}, children: [] }
            @data.last[:children] << element
          else
            @data.last[:children] << element
          end
        end

        table.remove
        self
      end

      def data
        @data || []
      end

      private

      def fetch_icons(data)
        return data if (icons = data[ICONS_KEY]).blank?

        data['icons'] = icons.split(Base::SPLIT_REGEX).reject(&:blank?).map { |i| i.strip.downcase }
        data
      end

      def parse_metadata(fragment)
        xpath = "table[.//*[case_insensitive_contains(text(), '#{METADATA_HEADER_LABEL}')]]"
        table = fragment.at_xpath(xpath, XpathFunctions.new)
        return {} unless table

        data = table.css('tr').map do |tr|
          key = tr.at_xpath('./td[1]').text.strip.downcase
          next if key.blank?

          value = tr.at_xpath('./td[2]').text.strip
          [key, value]
        end.compact

        fetch_materials(fetch_icons(data.to_h), MATERIALS_KEY)
          .transform_keys { |k| k.to_s.underscore }
      end

      def parse_metacognition(fragment)
        {
          content: fragment.content.gsub(DocTemplate::Tags::StandardTag::TAG_RE, '').strip,
          original_content: (fragment.inner_html unless fragment.content.blank?)
        }
      end
    end
  end
end
