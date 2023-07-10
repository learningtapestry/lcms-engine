# frozen_string_literal: true

module DocTemplate
  module Tags
    class ActivityMetadataSectionTag < BaseTag
      include DocTemplate::Tags::Helpers
      include ERB::Util

      TAG_NAME = 'activity-metadata-section'
      TEMPLATES = { default: 'group-math.html.erb',
                    gdoc: 'gdoc/group-math.html.erb' }.freeze

      def parse(node, opts = {})
        @opts = opts
        @section = @opts[:sections].level1_by_title(@opts[:value])
        @anchor = @section.anchor
        @materials = @section.material_ids

        before_materials = ''
        if (with_materials = @section.material_ids.any?)
          before_materials = content_until_materials node
          before_materials = parse_nested before_materials.to_s, opts
        end

        content = content_until_break node
        content.scan(DocTemplate::FULL_TAG).select { |t| t.first == ActivityMetadataTypeTag::TAG_NAME }.each do |(_, a)|
          @section.add_activity opts[:activity].find_by_anchor(a)
        end
        content = parse_nested content.to_s, opts
        params = {
          before_materials:,
          # TODO: check maybe it's ok to move it somewhere else,
          # fixed at #692 bc with new section we always have some garbage before activity
          content: DocTemplate.sanitizer.strip_html(content),
          placeholder: placeholder_id,
          react_props: {
            activity: {
              title: @section.title
            },
            group: true,
            material_ids: @section.material_ids
          },
          section: @section,
          with_materials:
        }
        @content = parse_template params, template_name(opts)
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::ActivityMetadataSectionTag::TAG_NAME, Tags::ActivityMetadataSectionTag)
end
