# frozen_string_literal: true

require 'acts-as-taggable-on'

module Lcms
  module Engine
    class Tag < ActsAsTaggableOn::Tag
      scope :where_context, ->(context) { joins(:taggings).where(taggings: { context: }) }
    end
  end
end
