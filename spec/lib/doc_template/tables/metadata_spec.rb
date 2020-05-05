# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tables::Metadata do
  let(:table) { described_class.new }

  describe '#parse' do
    let(:html) { Lcms::Engine::HtmlSanitizer.sanitize(data) }
    let(:fragment) { Nokogiri::HTML.fragment html }

    subject { table.parse fragment }

    shared_examples 'process metadata table' do
      include_examples 'removes metadata table'

      it { expect(subject.data['type']).to eq 'lesson' }
      it { expect(subject.data['guidebook-type']).to eq 'D2' }
      it { expect(subject.data['guidebook-title']).to eq 'A Lesson Before Dying' }
    end

    context 'regular header' do
      let(:data) { file_fixture('tables/document-metadata.html').read }

      include_examples 'process metadata table'
    end

    context 'header with spans' do
      let(:data) { file_fixture('tables/document-metadata-2spans.html').read }

      include_examples 'process metadata table'
    end

    context '2 paragraphs header with space' do
      let(:data) { file_fixture('tables/document-metadata-2paragpraphs.html').read }

      include_examples 'process metadata table'
    end
  end
end
