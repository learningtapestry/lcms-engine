# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceStandard < ApplicationRecord
      belongs_to :resource
      belongs_to :standard
    end
  end
end
