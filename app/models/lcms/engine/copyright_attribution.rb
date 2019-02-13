# frozen_string_literal: true

module Lcms
  module Engine
    class CopyrightAttribution < ActiveRecord::Base
      belongs_to :resource
      validates :resource_id, :value, presence: true
    end
  end
end
