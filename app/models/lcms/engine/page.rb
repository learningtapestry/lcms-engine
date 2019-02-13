# frozen_string_literal: true

module Lcms
  module Engine
    class Page < ActiveRecord::Base
      validates :body, :title, :slug, presence: true

      def full_title
        "UnboundEd - #{title}"
      end
    end
  end
end
