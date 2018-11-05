# frozen_string_literal: true

class AssociationItemSerializer < ActiveModel::Serializer
  self.root = false
  attributes :id, :name
end
