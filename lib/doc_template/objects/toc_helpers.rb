# frozen_string_literal: true

module DocTemplate
  module Objects
    module TocHelpers
      extend ActiveSupport::Concern

      def level1_by_title(title)
        l1 = children.find { |c| !c.handled && c.title.parameterize == title }
        raise DocumentError, "Level1 header #{title} not found at metadata" unless l1.present?

        l1.handled = true
        l1
      end

      def level2_by_title(title)
        children.each do |c|
          l2 = c.children.find { |c1| c1.title.parameterize == title }
          return l2 if l2.present?
        end
        raise DocumentError, "Level2 header #{title} not found at metadata"
      end

      def find_by_anchor(anchor)
        l1 = children.find { |c| c.anchor == anchor }
        raise DocumentError, "Anchor #{anchor} not found at metadata" if l1.blank?

        l1
      end

      # TODO: This will be needed for refactoring group/sections to lookup by anchors
      # def find_by_anchor(anchor)
      #   children.each do |s|
      #     result = s.children.detect { |c| c.anchor == anchor }
      #     return result if result.present?
      #   end
      #   raise DocumentError, "Anchor #{anchor} not found at metadata"
      # end

      class_methods do
        def set_index(data, params = { idx: 0 })
          return data if data['idx'].present?

          data['idx'] = params[:idx]
          params[:idx] += 1
          (data[:children] || []).each { |c| set_index(c, params) }
          data
        end
      end
    end
  end
end
