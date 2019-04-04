# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Component do
  let(:object) { Lcms::Engine::Component.new params: 'test' }

  it 'can be created' do
    expect(object).to be_present
  end

  describe '.component_types' do
    subject { described_class.component_types }

    it 'makes API request to types end-point' do
      expect(described_class).to receive(:api_request).with('/types')
      subject
    end
  end

  describe '.find' do
    let(:id) { 'id' }
    let(:response) { { key: 'value' } }

    before { allow(described_class).to receive(:api_request).and_return(response) }

    subject { described_class.find id }

    it 'makes API request' do
      expect(described_class).to receive(:api_request).with("/#{id}")
      subject
    end

    it 'returns new object instance based on API response' do
      expect(subject[:key]).to eq response[:key]
    end
  end

  describe '.search' do
    let(:params) { { key: 'value' } }
    let(:response) { { key: 'value' } }

    before do
      allow(described_class).to receive(:api_request).and_return(response)
      allow(described_class).to receive(:paginated_results)
    end

    subject { described_class.search params }

    it 'makes API request' do
      expect(described_class).to receive(:api_request).with('/', params)
      subject
    end

    it 'returns paginated results' do
      expect(described_class).to receive(:paginated_results).with(response)
      subject
    end
  end
end
