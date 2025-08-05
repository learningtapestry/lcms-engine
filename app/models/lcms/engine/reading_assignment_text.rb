# frozen_string_literal: true

module Lcms
  module Engine
    class ReadingAssignmentText < ApplicationRecord
      has_many :resource_reading_assignments
      has_many :resources, through: :resource_reading_assignments

      belongs_to :reading_assignment_author
      alias author reading_assignment_author
    end
  end
end
