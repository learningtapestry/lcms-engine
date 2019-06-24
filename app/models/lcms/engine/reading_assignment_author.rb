# frozen_string_literal: true

module Lcms
  module Engine
    class ReadingAssignmentAuthor < ApplicationRecord
      has_many :reading_assignment_texts
    end
  end
end
