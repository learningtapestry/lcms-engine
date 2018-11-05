# frozen_string_literal: true

class ResourcePickerSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :title
end
