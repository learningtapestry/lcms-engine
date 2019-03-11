# frozen_string_literal: true

module Lcms
  module Engine
    class SearchResourceSerializer < ResourceSerializer
      def initialize(obj, opts = {})
        super
        self.object = Resource.tree.find_by(id: object.model_id)
      end
    end
  end
end
