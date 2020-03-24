# frozen_string_literal: true

module Lcms
  module Engine
    class AssociationItemSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
