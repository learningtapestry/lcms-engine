# frozen_string_literal: true

FactoryGirl.define do
  factory :tagging, class: Lcms::Engine::Tag do
    context { 'context' }
    tag
  end
end
