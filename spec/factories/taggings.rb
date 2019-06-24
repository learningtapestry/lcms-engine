# frozen_string_literal: true

FactoryBot.define do
  factory :tagging, class: Lcms::Engine::Tagging do
    context { 'context' }
    tag { create :tag }
    taggable { create :resource }
  end
end
