# frozen_string_literal: true

module Lcms
  module Engine
    class Curriculum < ActiveRecord::Base
      has_many :resources, dependent: :nullify
      has_many :authors, -> { distinct }, through: :resources

      validates :name, :slug, presence: true, uniqueness: true

      def self.default
        where(default: true).first
      end
    end
  end
end
