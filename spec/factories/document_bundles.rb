# frozen_string_literal: true

FactoryBot.define do
  factory :document_bundle, class: Lcms::Engine::DocumentBundle do
    category { Lcms::Engine::DocumentBundle::CATEGORIES.sample }
    content_type { Lcms::Engine::DocumentBundle::CONTENT_TYPES.sample }
    resource
  end
end
