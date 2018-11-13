# frozen_string_literal: true

module DocTemplate
  module Tags
    class GroupTag < BaseTag
      include DocTemplate::Tags::Helpers

      TAG_NAME = 'group'
      TEMPLATES = {
        default: 'group-ela.html.erb',
        gdoc: 'gdoc/group-ela.html.erb'
      }.freeze

      def parse(node, opts = {})
        group = opts[:agenda].level1_by_title(opts[:value].parameterize)
        @anchor = group.anchor
        @materials = group.material_ids

        before_materials = ''
        if (with_materials = group.material_ids.any?)
          before_materials = content_until_materials node
          before_materials = parse_nested before_materials.to_s, opts
        end

        content = content_until_break node
        content = parse_nested content.to_s, opts
        params = {
          before_materials: before_materials,
          content: content,
          group: group,
          placeholder: placeholder_id,
          react_props: {
            activity: {
              title: group.title
            },
            group: true,
            material_ids: group.material_ids
          },
          with_materials: with_materials
        }
        @content = parse_template params, template_name(opts)
        replace_tag node
        self
      end
    end
  end

  Template.register_tag(Tags::GroupTag::TAG_NAME, Tags::GroupTag)
end
