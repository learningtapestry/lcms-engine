# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::StandardLink do
  it 'has valid factory' do
    expect(build :standard_link).to be_valid
  end
end
