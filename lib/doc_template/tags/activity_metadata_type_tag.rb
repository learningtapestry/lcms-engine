# frozen_string_literal: true

module DocTemplate
  module Tags
    class ActivityMetadataTypeTag < BaseTag
      include DocTemplate::Tags::Helpers
      include ERB::Util

      TAG_NAME = 'activity-metadata-type'
      TASK_RE = /(\[task:\s(#)\])/i
      TEMPLATES = {
        default: 'activity.html.erb',
        gdoc: 'gdoc/activity.html.erb'
      }.freeze

      def optional?
        !!@activity.try(:optional)
      end

      def parse(node, opts = {})
        @opts = opts
        @metadata = opts[:activity]
        @activity = @metadata.find_by_anchor(opts[:value])
        @anchor = @activity.anchor

        content = DocTemplate.sanitizer.strip_html(content_until_break(node))
        content = parse_nested content.to_s, opts
        params = {
          activity: @activity,
          content: DocTemplate.sanitizer.strip_html_element(content),
          placeholder: placeholder_id
        }

        # Extend basic params set with additional which can be customized
        params.merge! extended_parse_params

        @content = parse_template params, template_name(opts)
        @materials = @activity.try(:material_ids) || []
        replace_tag node
        self
      end

      private

      attr_reader :activity, :opts

      def extended_parse_params
        custom_params = ::DocTemplate::Tags.config[TAG_NAME]['extend-params-with'].to_s
        return extended_params_default if custom_params.blank?

        mod, method = custom_params.split('.')
        mod.constantize.send method
      end

      def extended_params_default
        if @activity.respond_to?(:activity_guidance)
          @activity[:activity_guidance] = DocTemplate.sanitizer.strip_html_element(@activity[:activity_guidance])
        end

        {
          priority_description: priority_description(activity),
          react_props: {
            activity: {
              title: @activity.title,
              type: @activity.activity_type
            },
            material_ids: @activity.material_ids
          }
        }
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataTypeTag::TAG_NAME, Tags::ActivityMetadataTypeTag)
end
