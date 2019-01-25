# frozen_string_literal: true

FactoryGirl.define do
  factory :leadership_post, class: Lcms::Engine::LeadershipPost do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
