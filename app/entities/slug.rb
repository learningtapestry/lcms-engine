# frozen_string_literal: true

class Slug
  attr_reader :resource

  def initialize(resource)
    @resource = resource
  end

  def value
    self.class.build_from(resource.directory)
  end

  def self.build_from(chain)
    chain.map(&:parameterize).join('/')
  end

  def self.generate_resources_slugs
    Resource.tree.find_each do |res|
      res.update_columns slug: Slug.new(res).value
    end
  end
end
