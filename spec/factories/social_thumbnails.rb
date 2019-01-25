# frozen_string_literal: true

FactoryGirl.define do
  factory :social_thumbnail, class: Lcms::Engine::SocialThumbnail do
    media { SocialThumbnail::MEDIAS.sample }
    target { build :resource }
  end
end
