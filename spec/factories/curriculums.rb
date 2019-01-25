# frozen_string_literal: true

FactoryGirl.define do
  factory :curriculum, class: Lcms::Engine::Curriculum do
    name 'EngageNY'
    slug 'engageny'
    default true
  end
end
