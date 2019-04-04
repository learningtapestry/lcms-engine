# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::ResourceAdditionalResource do
  it 'has valid factory' do
    expect(build :resource_additional_resource).to be_valid
  end
end
