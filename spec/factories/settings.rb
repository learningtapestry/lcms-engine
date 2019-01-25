# frozen_string_literal: true

FactoryGirl.define do
  factory :setting, class: Lcms::Engine::Settings do
    data { { editing_enabled: true } }
  end
end
