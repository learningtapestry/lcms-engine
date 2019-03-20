# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::GlsTag do
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end
  let(:original_content) do
    <<-HTML
      <p style=\"text-align:left\" class=\"indented\"><span> Every year thereafter Hindus in Ayodhya repeated the
      </span><span style=\"font-weight:700;\">custom </span><em>Define custom as something that is done as a tradition,
      year after year, over and over again.</em><em>Define custom as something that is done as a tradition, year after
      year, over and over again.</em><em>Define custom as something that is done as a tradition, year after year, over
      and over again.</em><em>Define custom as something that is done as a tradition, year after year, over and over
      again.</em><span>[G</span><span>LS: </span><span>#{value}]</span><span> of lighting lamps, honoring the strength
      and goodness of Rama. Gradually, the custom spread to other parts of the land.</span></p>
    HTML
  end
  let(:tag) { described_class.new }
  let(:tag_name) { DocTemplate::Tags::GlsTag::TAG_NAME }
  let(:value) { 'Define custom as something that is done as a tradition, year after year, over and over again.' }

  subject { tag.parse(node, value: value).render }

  it 'removes original node' do
    expect(subject).to_not include("[#{tag_name}]")
  end

  it 'substitues tag with value and wraps it' do
    expect(subject).to match %r{<em class="[^"]*">#{value}</em>}
  end
end
