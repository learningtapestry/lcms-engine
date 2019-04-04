# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Settings do
  it 'has valid factory' do
    expect(build :setting).to be_valid
  end

  describe 'storage for settings by keys' do
    let(:key) { :editing_enabled }
    let(:default_value) { true }
    let(:value) { 'value' }

    it 'creates initial settings for specified key' do
      expect(Lcms::Engine::Settings[key]).to eq default_value
    end

    it 'reads the settings by keys' do
      Lcms::Engine::Settings[:test] # to initiate empty settings
      Lcms::Engine::Settings.last.update data: { key => value }
      expect(Lcms::Engine::Settings[key]).to eq value
    end

    it 'writes settings by keys' do
      Lcms::Engine::Settings[key] = value
      expect(Lcms::Engine::Settings[key]).to eq value
    end

    it 'raises an error if unknown method is called' do
      expect { Lcms::Engine::Settings.fake }.to raise_error NoMethodError
    end
  end
end
