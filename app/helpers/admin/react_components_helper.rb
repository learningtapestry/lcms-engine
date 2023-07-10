# frozen_string_literal: true

module Admin
  module ReactComponentsHelper
    HIDDEN_FIELD_RE = /\b(?<=name=")[^"]+(?=")/

    #
    # @param [String] name
    # @param [Hash] props
    # @return [ActiveSupport::SafeBuffer] HTML content
    # @return [String] HTML content
    #
    def render_component(name, props)
      content_tag(:div, nil, id: "#lcms-engine-#{name}", data: { content: props.to_json })
    end
  end
end
