# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceAdditionalResource < ApplicationRecord
      belongs_to :resource
      belongs_to :additional_resource, class_name: 'Resource', foreign_key: 'additional_resource_id'
    end
  end
end
