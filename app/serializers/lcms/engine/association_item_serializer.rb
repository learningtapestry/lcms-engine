# frozen_string_literal: true

module Lcms
  module Engine
    class AssociationItemSerializer < ActiveModel::Serializer
      self.root = false
      attributes :id, :name
    end
  end
end
