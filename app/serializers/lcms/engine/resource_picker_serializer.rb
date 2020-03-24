# frozen_string_literal: true

module Lcms
  module Engine
    class ResourcePickerSerializer < ActiveModel::Serializer
      attributes :id, :title
    end
  end
end
