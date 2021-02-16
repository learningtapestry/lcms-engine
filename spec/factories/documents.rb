# frozen_string_literal: true

FactoryBot.define do
  factory :document, class: Lcms::Engine::Document do
    file_id { "file_#{SecureRandom.hex(6)}" }
  end
end
