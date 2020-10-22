# frozen_string_literal: true

module Lcms
  module Engine
    class ReactMaterialsResolver
      class << self
        def resolve(html, document)
          content = Nokogiri::HTML.fragment(html)
          content.css("[data-react-class='MaterialsContainer']").each do |node|
            replace_react(node, document)
          end
          content.to_html
        end

        private

        def replace_react(node, document) # rubocop:disable Metrics/PerceivedComplexity
          node.remove && return if (data = node.attr('data-react-props')).blank?

          raw_props = if data.match?(/^\d+(?:,\s*\d+)*$/)
                        # comma separated list of numbers, i.e: '123' or '123,432' or '123, 42, 12'
                        { 'material_ids' => data.split(',').map(&:strip), 'activity' => {} }
                      else
                        JSON.parse(data)
                      end
          node.remove && return if (raw_props['material_ids']).empty?

          props = PreviewsMaterialSerializer.new(raw_props, document)
          node.remove && return if props.data && props.data.empty?

          node.replace(component(props, document))
        end

        def component(props, document)
          h.react_component('MaterialsContainer', props, prerender: document.content_type != 'none')
        end

        def h
          ActionController::Base.helpers
        end
      end
    end
  end
end
