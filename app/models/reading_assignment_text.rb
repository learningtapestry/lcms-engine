# frozen_string_literal: true

class ReadingAssignmentText < Lcms::Engine::ApplicationRecord
  has_many :resource_reading_assignments
  has_many :resources, through: :resource_reading_assignments

  belongs_to :reading_assignment_author
  alias_attribute :author, :reading_assignment_author
end
