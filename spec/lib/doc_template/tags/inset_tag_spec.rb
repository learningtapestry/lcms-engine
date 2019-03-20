# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::InsetTag do
  let(:original_content) do
    <<-HTML
      <p><span>[inset]</span></p>
      <p><span style="font-weight:700;">displeases, </span><span style="font-style:italic;font-weight:700">adj</span><span style="font-weight:700;">.</span><span> Feeling unhappy or bothered about something.<br>Example: It displeases the baseball players when their game is canceled because of rain.<br>Variation(s): none</span></p>
      <p><span>[qrd: https://google.com; Link]<span></p>
      <p><span style="font-weight:700;">enchanted, </span><span style="font-style:italic;font-weight:700">adj.</span><span> As if under a magic spell<br></span><span style="font-style:italic;">Example:</span><span> Kate and Jack knew they were in an enchanted forest because there were jewels growing on the trees.<br></span><span style="font-style:italic;">Variation(s):</span><span> none</span></p>
      <p><span>[#{stop_tag}]</span></p><p>NOT THIS!</p>
    HTML
  end
  let(:stop_tag) { "#{described_class::TAG_NAME}: #{described_class::END_VALUE}" }
  let(:tag) { described_class.new }

  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end

  subject { tag.parse(node, value: '').content }

  it 'removes original node' do
    expect(subject).to_not include('[inset]')
  end

  it 'adds inset wrapper to paragraphs' do
    expect(subject).to match(/^<div class="o-ld-inset">/)
  end

  it 'does not includes nodes after the end tag' do
    expect(subject).to_not include('<p>NOT THIS!</p>')
  end

  it 'preserves styling' do
    expect(subject).to match(/class=".*text-bold.*"/)
    expect(subject).to match(/class=".*text-italic.*"/)
  end

  it 'parses nested tags' do
    expect(subject).to match(/{{qrd_tag_/)
  end

  it_behaves_like 'content_tag'
end
