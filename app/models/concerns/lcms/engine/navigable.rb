# frozen_string_literal: true

require 'active_support/concern'

module Lcms
  module Engine
    module Navigable
      extend ActiveSupport::Concern

      included do
        def parents
          ancestors.reverse
        end

        def previous
          @previous ||=
            if level_position.to_i.positive?
              siblings.where(level_position: level_position - 1).first
            else
              # last element of previous node from parent level
              parent.try(:previous).try(:children).try(:last)
            end
        end

        def next
          @next ||=
            if level_position.nil?
              nil
            elsif level_position < siblings.size
              siblings.where(level_position: level_position + 1).first
            else
              # first element of next node from parent level
              parent.try(:next).try(:children).try(:first)
            end
        end
      end
    end
  end
end
