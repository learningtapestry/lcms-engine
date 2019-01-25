# frozen_string_literal: true

FactoryGirl.define do
  factory :resource_additional_resource, class: Lcms::Engine::ResourceAdditionalResource do
    resource { build :resource }
    additional_resource { build :resource }
  end
end
