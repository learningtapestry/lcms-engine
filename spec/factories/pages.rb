# frozen_string_literal: true

FactoryBot.define do
  factory :page, class: Lcms::Engine::Page do
    body { Faker::Lorem.sentence(word_count: 100) }
    title { Faker::Lorem.sentence(word_count: 10) }
    slug { Faker::Internet.slug }

    trait :about do
      body { 'About us' }
      title { 'About' }
      slug { 'about' }
    end

    trait :tos do
      body { 'Terms of Service' }
      slug { 'tos' }
      title { 'Terms of Service' }
    end
  end
end
