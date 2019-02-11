# frozen_string_literal: true

module Lcms
  module Engine
    class DocumentPart < ActiveRecord::Base
      belongs_to :document

      enum context_type: { default: 0, gdoc: 1 }

      default_scope { active }

      scope :active, -> { where(active: true) }
      scope :general, -> { where(optional: false) }
      scope :optional, -> { where(optional: true) }
    end
  end
end
