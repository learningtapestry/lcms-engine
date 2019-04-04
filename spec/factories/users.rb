# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: Lcms::Engine::User do
    access_code { create(:access_code).code }
    confirmed_at { Time.current }
    sequence(:email) { |n| "email#{n}@test.com" }
    name { 'Unbounded User' }
    password { '12345678' }
    password_confirmation { '12345678' }
    survey { { key: 'value' } }

    factory :admin, class: Lcms::Engine::User do
      name { 'Admin User' }
      role { 'admin' }
    end
  end
end
