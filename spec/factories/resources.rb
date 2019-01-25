# frozen_string_literal: true

FactoryGirl.define do
  factory :resource, class: Lcms::Engine::Resource do
    curriculum { Curriculum.default || create(:curriculum) }
    curriculum_type 'lesson'
    metadata(subject: 'ela', grade: 'grade 2', 'module': 'module 1',
             unit: 'unit 1', lesson: 'lesson 1')
    resource_type Resource.resource_types[:resource]
    title 'Test Resource'
    tree true
    url 'Resource URL'

    trait :grade do
      curriculum_type 'grade'
      metadata(subject: 'ela', grade: 'grade 2')
    end

    trait :module do
      curriculum_type 'module'
      metadata(subject: 'ela', grade: 'grade 2', 'module': 'module 1')
    end
  end
end
