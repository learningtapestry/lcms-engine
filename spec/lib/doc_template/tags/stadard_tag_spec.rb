# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::StandardTag do
  let(:original_content) do
    <<-HTML
      <ul class="lst-kix_nxend745gryj-0 start">
        <li class='preserved-cls'><span>Use words and phrases acquired through conversations, reading and being read to, and responding to the text </span><span>[</span><span>#{standard_name}</span><span>].</span></li>
        <li><span>Prior to listening to </span><span>The Fisherman and His Wife</span><span>, orally predict which character has magical powers and then compare the actual outcome to the prediction</span><span>.</span></li>
      </ul>
    HTML
  end
  let(:standard_name) { 'L.2.6' }
  let(:tag) { described_class.new }
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//li') # it's the parent node of the one containing the tag itself
  end

  subject { tag.parse(node, {}).content }

  it 'fetches DB for the description of a stadard' do
    expect(Lcms::Engine::Standard).to receive(:search_by_name).with(standard_name.downcase.to_sym).and_call_original
    subject
  end

  it 'renders corresponding template' do
    expect(ERB).to receive_message_chain(:new, :result).and_return('')
    subject
  end

  context 'when node is a list' do
    subject { tag.parse(node, {}).render }

    it 'preserves <li> markup with class' do
      expect(subject).to include '<li class="preserved-cls">'
      expect(subject).to include '</li>'
    end
  end
end
