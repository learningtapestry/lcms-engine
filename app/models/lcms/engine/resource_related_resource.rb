# frozen_string_literal: true

module Lcms
  module Engine
    class ResourceRelatedResource < ActiveRecord::Base
      belongs_to :resource
      belongs_to :related_resource, class_name: 'Resource', foreign_key: 'related_resource_id'
    end
  end
end
