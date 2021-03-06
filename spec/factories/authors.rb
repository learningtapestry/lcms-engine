# frozen_string_literal: true

FactoryBot.define do
  factory :author, class: Lcms::Engine::Author do
    name { 'Great Minds' }
    slug { 'great-minds' }
  end
end
