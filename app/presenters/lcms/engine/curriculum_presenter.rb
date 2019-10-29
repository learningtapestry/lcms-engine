# frozen_string_literal: true

module Lcms
  module Engine
    # Simple presenter for Curriculum (resources tree)
    class CurriculumPresenter
      UNIT_LEVEL = Lcms::Engine::Resource.hierarchy.index(:unit)

      def editor_props
        @editor_props ||= {
          tree: jstree_data,
          form_url: routes.admin_curriculum_path
        }
      end

      private

      # Parse tree to be compatible with jstree input data
      def jstree_data
        Resource.tree.ordered.roots.map { |res| parse_jstree_node(res) }
      end

      def opened?(node)
        return false if node.curriculum_type.blank?

        level = Lcms::Engine::Resource.hierarchy.index(node.curriculum_type.to_sym)
        level < UNIT_LEVEL
      end

      def parse_jstree_node(node)
        {
          id: node.id,
          text: node.short_title,
          state: { opened: opened?(node) },
          children: node.children.tree.ordered.map { |res| parse_jstree_node(res) },
          li_attr: { title: node.title }
        }
      end

      def routes
        Lcms::Engine::Engine.routes.url_helpers
      end
    end
  end
end
