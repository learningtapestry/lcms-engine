# frozen_string_literal: true

class ResourceReadingAssignment < Lcms::Engine::ApplicationRecord
  belongs_to :reading_assignment_text
  belongs_to :resource
end
