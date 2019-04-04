# frozen_string_literal: true

require 'rails_helper'

describe DocumentExporter::Docx do
  describe '#export' do
    let(:content) { 'content' }
    let(:generated_content) { 'generated content' }
    let(:document) { create :document }

    before do
      allow(ApplicationController).to receive(:render).and_return(content)
      allow(PandocRuby).to receive(:convert).and_return(generated_content)
    end

    subject { described_class.new(document).export }

    it 'calls Pandoc wrapper' do
      expect(PandocRuby).to receive(:convert).with(content, from: :html, to: :docx)
      subject
    end

    it 'returns generated data' do
      expect(subject).to eq generated_content
    end
  end
end
