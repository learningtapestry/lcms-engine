# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags do
  describe 'config storage' do
    it 'stores config in module instance variable' do
      expect(described_class.config).to be_a(Hash)
    end
  end

  describe '.substitute_tags_in' do
    context 'when content is blank' do
      it 'returns an empty string' do
        expect(described_class.substitute_tags_in('')).to eq('')
        expect(described_class.substitute_tags_in(nil)).to eq('')
      end
    end

    context 'when content is not blank' do
      let(:content) { "This is [b]bold[b:end]. \n This is [i]italic[i:end]" }
      let(:tag_content) { 'This is <b>bold</b>. <br/> This is <i>italic</i>' }

      subject { described_class.substitute_tags_in(content) }

      it 'returns content with substitutions' do
        expect(subject).to eq(tag_content)
      end
    end
  end
end
