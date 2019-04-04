# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::MultipleChoiceTag do
  let(:original_content) do
    <<-HTML
      <p><span>[multiple-choice]</span></p>
      <p><span>Choice 1</span><span>Blabla blabla bla<br>Bla Bla bla</span></p>
      <p><span>Choice 2</span><span>Bleble bleble ble<br>Ble Ble ble</span></p>
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
    expect(subject).to_not include('[multiple-choice]')
  end

  it 'adds wrapper div with the right styling class' do
    expect(subject).to match(/^<div class="o-ld-multiple-choice">/)
  end

  it 'does not includes nodes after the end tag' do
    expect(subject).to_not include('<p>NOT THIS!</p>')
  end

  it_behaves_like 'content_tag'
end
