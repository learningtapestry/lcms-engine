# frozen_string_literal: true

class ReadingAssignmentAuthor < Lcms::Engine::ApplicationRecord
  has_many :reading_assignment_texts
end
