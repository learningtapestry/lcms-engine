# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tables::MaterialMetadata do
  let(:table) { described_class.new }

  describe '#parse' do
    let(:html) { Lcms::Engine::HtmlSanitizer.sanitize(data) }
    let(:fragment) { Nokogiri::HTML.fragment html }

    subject { table.parse fragment }

    context 'table with headers' do
      let(:data) { file_fixture('tables/material-metadata-theader.html').read }

      include_examples 'removes metadata table'

      it 'fetching all fields' do
        expect(subject.data['type']).to eq 'AK'
        expect(subject.data['title']).to eq 'Ashoka Reading (Teacher Version)'
        expect(subject.data['grade']).to eq '7'
        expect(subject.data['unit']).to eq '1'
        expect(subject.data['cluster']).to eq '4'
      end
    end
  end
end
