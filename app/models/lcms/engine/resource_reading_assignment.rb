# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceReadingAssignment < ApplicationRecord
      belongs_to :reading_assignment_text
      belongs_to :resource
    end
  end
end
