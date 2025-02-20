# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::ImageTag do
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//table/thead/tr[1]/td[1]')
  end
  let(:metadata) { { 'grade' => '5', 'unit' => '1', 'subject' => 'Math' } }
  let(:opts) { { value: 'example_image', metadata: } }
  let(:original_content) do
    <<-HTML
      <table>
        <thead>
          <tr><td>[#{described_class::TAG_NAME}]</td></tr>
          <tr><td>Caption text</td></tr>
        </thead>
      </table>
    HTML
  end
  let(:tag) { described_class.new }
  subject { tag.parse(node, opts) }

  describe '#parse_table' do
    it 'removes original node' do
      expect(subject.content).to_not include("[#{described_class::TAG_NAME}]")
    end

    it 'substitues tag with image with caption' do
      expect(subject.content).to include('figcaption>Caption text</figcaption>')
    end
  end
end
