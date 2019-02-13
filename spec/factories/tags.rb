# frozen_string_literal: true

FactoryBot.define do
  factory :tag, class: Lcms::Engine::Tag do
    name { Faker::Lorem.words }
  end
end
