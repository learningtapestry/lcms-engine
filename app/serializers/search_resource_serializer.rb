# frozen_string_literal: true

class SearchResourceSerializer < ResourceSerializer
  def initialize(obj, opts = {})
    super
    self.object = Resource.tree.find_by(id: object.model_id)
  end
end
