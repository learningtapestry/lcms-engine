# frozen_string_literal: true

module DocTemplate
  module Objects
    class ActivityMetadata
      include Virtus.model
      include DocTemplate::Objects::TocHelpers

      class Activity
        include Virtus.model
        include DocTemplate::Objects::MetadataHelpers

        attribute :activity_type, String
        attribute :activity_title, String
        attribute :activity_source, String
        attribute :activity_source_materials, String
        attribute :activity_materials, String
        attribute :activity_standard, String
        attribute :activity_mathematical_practice, String
        attribute :activity_time, Integer, default: 0
        attribute :activity_priority, Integer, default: 0
        attribute :activity_metacognition, String
        attribute :activity_guidance, String
        attribute :activity_content_development_notes, String
        attribute :alert, String
        attribute :optional, Boolean, default: false

        # aliases to build toc
        attribute :anchor, String
        attribute :handled, Boolean, default: false
        attribute :idx, Integer
        attribute :level, Integer, default: 2
        attribute :priority, Integer, default: ->(a, _) { a.activity_priority }
        attribute :standard, String, default: ->(s, _) { s.activity_standard }
        attribute :title, String, default: ->(a, _) { a.activity_title }
        attribute :time, Integer, default: ->(a, _) { a.activity_time }

        attribute :material_ids, Array[Integer], default: []

        def activity_standard_info
          standard_info [activity_standard, activity_mathematical_practice]
        end
      end

      attribute :children, Array[Activity]
      attribute :idx, Integer
      attribute :task_counter, Hash[String => Integer], default: {}

      def self.build_from(data)
        copy = Marshal.load Marshal.dump(data)
        activity_data =
          copy.map do |d|
            d.transform_keys! { |k| k.to_s.underscore }
            d['activity_time'] = d['activity_time'].to_s[/\d+/].to_i
            d['optional'] = d['optional']&.casecmp('optional')&.zero?
            d
          end
        new(set_index(children: activity_data))
      end
    end
  end
end
