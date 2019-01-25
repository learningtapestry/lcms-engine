# frozen_string_literal: true

FactoryGirl.define do
  factory :material, class: Lcms::Engine::Material do
    sequence(:identifier, 'a') { |n| n }
    file_id { "file_#{SecureRandom.hex(6)}" }
  end
end
