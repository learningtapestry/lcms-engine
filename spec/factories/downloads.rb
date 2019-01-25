# frozen_string_literal: true

FactoryGirl.define do
  factory :download, class: Lcms::Engine::Download do
    title { Faker::Lorem.words.join '' }
    url { Faker::Internet.url }
  end
end
