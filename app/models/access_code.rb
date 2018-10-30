# frozen_string_literal: true

class AccessCode < Lcms::Engine::ApplicationRecord
  validates :code, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :by_code, ->(value) { active.where('lower(code) = ?', value.downcase) }
end
