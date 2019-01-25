# frozen_string_literal: true

FactoryGirl.define do
  factory :standard, class: Lcms::Engine::Standard do
    subject { %w(ela math).sample }
    name 'name'
  end
end
