# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tables::Activity do
  let(:table) { described_class.new }

  describe '#parse' do
    let(:data) { file_fixture('tables/activity-metadata-3activities.html').read }
    let(:html) { Lcms::Engine::HtmlSanitizer.sanitize(data) }
    let(:fragment) { Nokogiri::HTML.fragment html }

    subject { table.parse fragment }

    include_examples 'removes metadata table'

    it 'processed 3 acivities' do
      expect(subject.size).to eq 3
    end

    it 'processed data from acivities' do
      subject.each_with_index do |activity, idx|
        expect(activity['number'].to_i).to eq idx + 1
        expect(activity['class-configuration']).to eq 'Whole class'
      end
    end
  end
end
