# frozen_string_literal: true

class BundleGenerator
  def self.perform(resource)
    DocumentBundle::CATEGORIES.each { |c| DocumentBundleGenerateJob.perform_later resource, category: c }
  end
end
