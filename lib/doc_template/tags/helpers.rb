# frozen_string_literal: true

module DocTemplate
  module Tags
    module Helpers
      include ActionView::Helpers::TagHelper
      ICON_PATH = 'http://s3.amazonaws.com/ubpilot-uploads/assets'

      def materials_container(props)
        return if props.nil?

        content_tag :div, nil, data: { react_class: 'MaterialsContainer', react_props: props }
      end

      def priority_description(activity)
        priority = activity.try(:activity_priority) || activity.priority
        return unless priority.present?

        config = Tags.config[self.class::TAG_NAME.downcase]
        Array.wrap(config['priority_descriptions'])[priority - 1]
      end

      def priority_icon(activity)
        return unless activity.priority.present?

        # for some odd reason inlined images aren't working at gdoc
        # this is why we reference s3
        "#{ICON_PATH}/ld_p#{activity.priority}.png"
      end
    end
  end
end
