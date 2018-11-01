# frozen_string_literal: true

#
# Simple abstraction for external pages (e.g. ub blog pages) used on Search
#
class ExternalPage
  include Virtus.model

  attribute :description, String
  attribute :permalink, String
  attribute :slug, String
  attribute :keywords, Array[String], default: []
  attribute :teaser, String
  attribute :title, String

  def model_type
    :page
  end
end
