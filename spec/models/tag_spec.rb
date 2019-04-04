# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Tag do
  it 'has valid factory' do
    expect(build :tag).to be_valid
  end
end
