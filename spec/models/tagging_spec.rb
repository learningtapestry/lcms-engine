# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Tagging do
  it 'has valid factory' do
    expect(build :tagging).to be_valid
  end
end
