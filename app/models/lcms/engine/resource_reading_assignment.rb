# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceReadingAssignment < ActiveRecord::Base
      belongs_to :reading_assignment_text
      belongs_to :resource
    end
  end
end
