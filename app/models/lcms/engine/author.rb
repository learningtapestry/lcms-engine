# frozen_string_literal: true

module Lcms
  module Engine
    class Author < ActiveRecord::Base
      has_many :resources
      has_many :curriculums, -> { distinct }, through: :resources
    end
  end
end
