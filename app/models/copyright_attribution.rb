# frozen_string_literal: true

class CopyrightAttribution < Lcms::Engine::ApplicationRecord
  belongs_to :resource
  validates :resource_id, :value, presence: true
end
