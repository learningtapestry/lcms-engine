# frozen_string_literal: true

module Lcms
  module Engine
    class BundleGenerator
      def self.perform(resource)
        DocumentBundle::CATEGORIES.each { |c| DocumentBundleGenerateJob.perform_later resource, category: c }
      end
    end
  end
end
