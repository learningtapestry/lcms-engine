# frozen_string_literal: true

require 'acts-as-taggable-on'

class Tag < ActsAsTaggableOn::Tag
  scope :where_context, ->(context) { joins(:taggings).where(taggings: { context: context }) }
end
