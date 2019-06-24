# frozen_string_literal: true

FactoryBot.define do
  factory :standard_link, class: Lcms::Engine::StandardLink do
    standard_begin { build :standard }
    standard_end { build :standard }
  end
end
