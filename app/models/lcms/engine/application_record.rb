# frozen_string_literal: true

module Lcms
  module Engine
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
