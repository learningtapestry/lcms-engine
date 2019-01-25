# frozen_string_literal: true

module Lcms
  module Engine
    class MaterialPart < ActiveRecord::Base
      belongs_to :material
      enum context_type: { default: 0, gdoc: 1 }

      default_scope { active }

      scope :active, -> { where(active: true) }
    end
  end
end
