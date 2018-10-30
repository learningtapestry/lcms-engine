# frozen_string_literal: true

class ResourceStandard < Lcms::Engine::ApplicationRecord
  belongs_to :resource
  belongs_to :standard
end
