# frozen_string_literal: true

class ResourceRelatedResource < Lcms::Engine::ApplicationRecord
  belongs_to :resource
  belongs_to :related_resource, class_name: 'Resource', foreign_key: 'related_resource_id'
end
