# frozen_string_literal: true

module DocTemplate
  module Tables
    class Activity < Base
      HEADER_LABEL = 'activity-metadata'
      HTML_VALUE_FIELDS = %w(about-the-activity-student about-the-activity-teacher activity-metacognition
                             activity-guidance alert class-configuration-student reading-purpose).freeze
      MATERIALS_KEY = 'materials'

      def parse(fragment, template_type = 'core')
        path = ".//table/*/tr[1]/td//*[case_insensitive_equals(text(),'#{HEADER_LABEL}')]"
        idx = 0
        [].tap do |result|
          fragment.xpath(path, XpathFunctions.new).each do |el|
            table = el.ancestors('table').first
            data = fetch table

            data = process_title(data)

            # Places activity type tags
            if data['activity-title'].present?
              idx += 1
              # we define the tag value as an unique(-ish) anchor, so we can retrieve this activity
              # info later (check toc_helpers#find_by_anchor). Used for building the sections TOC
              value = "#{idx}-#{template_type}-l2-#{data['activity-title']}".parameterize
              data['idx'] = idx
              data['anchor'] = value
              header = "<p><span>[#{::DocTemplate::Tags::ActivityMetadataTypeTag::TAG_NAME}: #{value}]</span></p>"
              table.add_next_sibling header
            end

            table.remove
            data = fetch_materials data, MATERIALS_KEY

            result << data
          end
        end
      end

      def process_title(data)
        # Allows to handle ELA as Math:
        # - inject `section-title` to link to fake section
        # - substitute activity title
        data['section-title'] ||= Tables::Section::FAKE_SECTION_TITLE
        data['activity-title'] ||= data['number']
        data
      end
    end
  end
end
