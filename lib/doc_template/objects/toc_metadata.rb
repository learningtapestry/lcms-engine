# frozen_string_literal: true

module DocTemplate
  module Objects
    class TocMetadata
      include Virtus::InstanceMethods::Constructor
      include Virtus.model

      class Heading
        include Virtus.model

        attribute :anchor, String
        attribute :children, Array, default: [] # Array[Heading]
        attribute :level, Integer
        attribute :material_ids, Array, default: []
        attribute :optional, Virtus::Attribute::Boolean, default: false
        attribute :priority, Integer, default: 0
        attribute :standard, String, default: ''
        attribute :time, Integer, default: 0
        attribute :title, String

        def excluded?(excludes, ela: false)
          # Do not exclude parent if all children are optional and deselected
          return false if ela && children.all?(&:optional)
          return excludes.exclude?(anchor) if optional
          return true if excludes.include?(anchor)

          children.any? && children.all? { |c| c.excluded?(excludes) }
        end

        def time_with(excludes)
          # Optional and nothing to exclude explicitly
          return excludes.include?(anchor) ? time : 0 if optional
          # General and excluded explicitly
          return 0 if excludes.include?(anchor)

          # do not recalculate time if
          # - there are no optional children
          # - no excludes passed
          # - there are no children at all
          if children.blank? || excludes.blank?
            time
          else
            children.sum { |c| c.time_with(excludes) }
          end
        end
      end

      attribute :children, Array, default: [] # Array[Heading]
      attribute :priority, Integer, default: 0
      attribute :total_time, Integer, default: ->(t, _) { t.children.sum(&:time) }

      class << self
        def dump(data)
          data.as_json
        end

        def load(data)
          new(data)
        end
      end

      def append(toc)
        children.concat toc.children
        update_time
      end

      def collect_children
        children + children.flat_map(&:children)
      end

      def collect_material_ids
        collect_children.flat_map(&:material_ids).compact.uniq
      end

      def ordered_material_ids
        [].tap do |ids|
          children.each do |x|
            ids.concat x.material_ids
            ids.concat x.children.flat_map(&:material_ids)
          end
        end.compact
      end

      def prepend(toc)
        children.unshift(*toc.children)
        update_time
      end

      def total_time_with(excludes)
        has_optionals = children.any? { |l1| l1.children.any?(&:optional) }
        if has_optionals || excludes.any?
          children.sum { |c| c.time_with(excludes) }
        else
          total_time
        end
      end

      private

      def update_time
        self.total_time = children.sum(&:time).to_i
      end
    end
  end
end
