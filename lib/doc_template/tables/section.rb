# frozen_string_literal: true

module DocTemplate
  module Tables
    class Section < Base
      FAKE_SECTION_TITLE = 'lesson'
      HEADER_LABEL = 'section-metadata'
      HTML_VALUE_FIELDS = ['section-summary'].freeze
      MATERIALS_KEY = 'section-materials'

      def parse(fragment, *args)
        section_tables = fragment.xpath(xpath_meta_headers, XpathFunctions.new)

        # # Allows to handle ELA as Math:: inject fake section
        return fake_section(fragment) if section_tables.empty? && args.extract_options![:force_inject]

        [].tap do |result|
          section_tables.each do |el|
            table = el.ancestors('table').first
            data = fetch table

            value = data['section-title'].parameterize
            table.replace section_placeholder(value)

            data = fetch_materials data, MATERIALS_KEY

            result << data
          end
        end
      end

      private

      def fake_section(fragment)
        if fragment.children.empty?
          fragment.add_child Nokogiri::HTML.fragment(section_placeholder(FAKE_SECTION_TITLE))
        else
          fragment.children.first.before section_placeholder(FAKE_SECTION_TITLE)
        end
        [{ 'section-title' => FAKE_SECTION_TITLE }]
      end

      def section_placeholder(value)
        "<p><span>[#{::DocTemplate::Tags::ActivityMetadataSectionTag::TAG_NAME}: #{value}]</span></p>"
      end
    end
  end
end
