# frozen_string_literal: true

FactoryGirl.define do
  factory :tag, class: Lcms::Engine::Tag do
    name { Faker::Lorem.words }
  end
end
