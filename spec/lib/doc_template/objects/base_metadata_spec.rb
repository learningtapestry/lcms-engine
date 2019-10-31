# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Objects::BaseMetadata do
  describe '.split_field' do
    let(:content) { parts.join separator }
    let(:parts) { %w(a b c d e) }
    let(:separator) { '-' }

    subject { described_class.split_field content, separator }

    it 'returns splitted string' do
      expect(subject).to eq parts
    end
  end
end
