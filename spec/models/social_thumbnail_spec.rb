# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::SocialThumbnail do
  it 'has valid factory' do
    expect(build :social_thumbnail).to be_valid
  end

  context 'cannot be created' do
    it 'without target' do
      expect(build :social_thumbnail, target: nil).to_not be_valid
    end

    it 'without valid media type' do
      expect(build :social_thumbnail, media: 'fake').to_not be_valid
    end
  end
end
