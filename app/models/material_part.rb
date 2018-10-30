# frozen_string_literal: true

class MaterialPart < Lcms::Engine::ApplicationRecord
  belongs_to :material
  enum context_type: { default: 0, gdoc: 1 }

  default_scope { active }

  scope :active, -> { where(active: true) }
end
