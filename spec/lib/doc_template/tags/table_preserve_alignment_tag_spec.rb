# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::TablePreserveAlignmentTag do
  let(:node) { Nokogiri::HTML(original_content).at_xpath('*//p') }
  let(:original_content) do
    <<-HTML
      <p><span>[#{described_class::TAG_NAME}]</span></p>
      <table><tr><td><p style="text-align:#{style}">sfdfdf</p></td></tr></table>
    HTML
  end
  let(:tag) { described_class.new }
  let(:style) { 'right' }

  subject { tag.parse(node).content }

  it 'add css class depends on text align' do
    expect(subject).to include %(class="text-#{style}")
  end
end
