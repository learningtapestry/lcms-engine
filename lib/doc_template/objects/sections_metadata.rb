# frozen_string_literal: true

module DocTemplate
  module Objects
    class SectionsMetadata
      include Virtus::InstanceMethods::Constructor
      include Virtus.model
      include DocTemplate::Objects::TocHelpers

      class Section
        include Virtus::InstanceMethods::Constructor
        include Virtus.model

        attribute :children, Array[DocTemplate::Objects::ActivityMetadata::Activity] # rubocop:disable Style/RedundantArrayConstructor
        attribute :summary, String
        attribute :time, Integer, default: 0
        attribute :title, String
        attribute :template_type, String, default: 'core'

        # aliases to build toc
        attribute :handled, Virtus::Attribute::Boolean, default: false
        attribute :idx, Integer
        attribute :level, Integer, default: 1
        attribute :anchor, String, default: ->(a, _) { DocTemplate::Objects::MetadataHelpers.build_anchor_from(a) }

        attribute :material_ids, Array, default: []

        def add_activity(activity)
          self.time += activity.time.to_i
          activity.handled = true
          children << activity
        end
      end

      attribute :children, Array[Section] # rubocop:disable Style/RedundantArrayConstructor
      attribute :idx, Integer

      def self.build_from(data)
        copy = Marshal.load Marshal.dump(data)
        sections = copy.map do |metadata|
          metadata[:summary] = DocTemplate.sanitizer.strip_html_element(metadata[:summary])
          metadata.transform_keys { |k| k.to_s.gsub('section-', '').underscore }
        end
        new(set_index(children: sections))
      end

      def add_break
        idx = children.index { |c| !c.handled } || -1
        section = Section.new(title: 'Foundational Skills Lesson', anchor: 'optbreak', time: 0, children: [])
        children.insert(idx - 1, section)
      end
    end
  end
end
