# frozen_string_literal: true

module Lcms
  module Engine
    class CopyrightAttribution < ApplicationRecord
      belongs_to :resource
      validates :resource_id, :value, presence: true
    end
  end
end
