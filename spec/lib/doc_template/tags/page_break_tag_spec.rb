# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::PageBreakTag do
  let(:node) { Nokogiri::HTML(original_content).at_xpath('*//p') }
  let(:original_content) { '<p><span>[page-break]</span></p>' }
  let(:options) { {} }
  let(:tag) { described_class.new }
  let(:cls) { 'u-pdf-alwaysbreak do-not-strip' }

  subject { tag.parse(node, options).content }

  it 'substitutes the tag' do
    expect(subject).to_not include '[page-break]'
    expect(subject).to include %(<div class="#{cls}">)
  end

  context 'when it is GDoc view' do
    let(:options) { { context_type: 'gdoc' } }

    it 'substitutes the tag' do
      expect(subject).to_not include '[page-break]'
      expect(subject).to include '<p>--GDOC-PAGE-BREAK--</p>'
    end
  end

  context 'with soft returns on tag' do
    let(:original_content) { '<p><span>[page-break]</span>some content</p>' }

    it { expect { subject }.to raise_error(DocumentError) }
  end
end
