# frozen_string_literal: true

FactoryGirl.define do
  factory :document_part, class: Lcms::Engine::DocumentPart do
    document nil
    content 'MyText'
    part_type 'layout'
    active true
  end
end
