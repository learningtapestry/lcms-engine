# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::SmpTag do
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end
  let(:original_content) do
    <<-HTML
      <p><span>[smp: #{smp_value}]</span></p><p><span>T: Today we&rsquo;re going to practice unit form counting. This </span>
      </p><p><span>time we&rsquo;ll include hundreds! The unit form way to say 324 is 3 hundreds 2 tens 4 ones. (Pull the cards apart to show the 300, 20, and 4.) </span>
      </p><p><span></span></p><p><span></span></p><a id="t.db6a1f0d703e0579c496bd3f0aa8cbf23a66d6d6"></a><a id="t.5"></a>
      <p><span>T: Try this number. (Show 398. Signal.) </span></p><p><span>S: 3 hundreds 9 tens 8 ones. </span></p><p><span>T: (Pull cards apart.) That&rsquo;s right! </span>
      </p><p><span>[qrd: https://google.com; Link]<span></p><p><span>T: Let&rsquo;s count on from 398 the unit form way. (Display 399&ndash;405 with Hide Zero cards as students count.) </span>
      </p><p><span>S: 3 hundreds 9 tens 9 ones, 4 hundreds, 4 hundreds 1 one, 4 hundreds 2 ones, 4 hundreds 3 ones, 4 hundreds 4 ones, 4 hundreds 5 ones.</span>
      </p><p><span>[#{stop_tag}]</span></p><p>NOT THIS!</p>
    HTML
  end
  let(:smp_value) { 'MP.6; MP.12' }
  let(:stop_tag) { "#{described_class::TAG_NAME}: #{described_class::END_VALUE}" }
  let(:tag) { described_class.new }

  subject { tag.parse(node, value: smp_value).content }

  it 'removes original node' do
    expect(subject).to_not include("[smp: #{smp_value}]")
  end

  it 'adds wrapper' do
    expect(subject).to match(/^<div class="o-ld-smp">/)
  end

  it 'does not includes nodes after the end tag' do
    expect(subject).to_not include('<p>NOT THIS!</p>')
  end

  it 'parses nested tags' do
    expect(subject).to match(/{{qrd_tag_/)
  end

  it_behaves_like 'content_tag'
end
