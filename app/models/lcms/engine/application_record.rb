# frozen_string_literal: true

module Lcms
  module Engine
    # Main abstract application model
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
