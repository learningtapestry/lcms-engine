# frozen_string_literal: true

require 'rails_helper'

describe TextToImage do
  let(:data) { 'image raw data' }
  let(:service) { described_class.new text }
  let(:text) { 'Image text' }

  before { allow(MiniMagick::Tool::Convert).to receive(:new).and_return(data) }

  describe '#raw' do
    it 'returns raw image data' do
      expect(service.raw).to eq data
    end
  end
end
