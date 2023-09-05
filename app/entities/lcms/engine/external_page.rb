# frozen_string_literal: true

module Lcms
  module Engine
    #
    # Simple abstraction for external pages (e.g. ub blog pages) used on Search
    #
    class ExternalPage
      include Virtus.model

      attribute :description, String
      attribute :permalink, String
      attribute :slug, String
      attribute :keywords, Array, default: []
      attribute :teaser, String
      attribute :title, String

      def model_type
        :page
      end
    end
  end
end
