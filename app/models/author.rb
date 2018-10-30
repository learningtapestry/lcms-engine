# frozen_string_literal: true

class Author < Lcms::Engine::ApplicationRecord
  has_many :resources
  has_many :curriculums, -> { distinct }, through: :resources
end
