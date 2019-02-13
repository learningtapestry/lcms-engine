# frozen_string_literal: true

FactoryBot.define do
  factory :access_code, class: Lcms::Engine::AccessCode do
    sequence(:code) { |n| "code#{n}" }
  end
end
