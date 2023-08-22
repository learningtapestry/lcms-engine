# frozen_string_literal: true

module DocTemplate
  module Tags
    module Helpers
      include ActionView::Helpers::TagHelper

      def materials_container(props)
        return if props.nil?

        content_tag(:div, nil, data: { react_class: 'MaterialsContainer', react_props: props }) { _1 }
      end

      def priority_description(activity)
        priority = activity.try(:activity_priority) || activity.priority
        return unless priority.present?

        config = Tags.config[self.class::TAG_NAME.downcase]
        Array.wrap(config['priority_descriptions'])[priority - 1]
      end
    end
  end
end
