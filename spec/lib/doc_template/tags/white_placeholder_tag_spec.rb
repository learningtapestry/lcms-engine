# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::WhitePlaceholderTag do
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end
  let(:stop_tag) { "#{described_class::TAG_NAME}: #{described_class::END_VALUE}" }
  let(:tag) { described_class.new }
  subject { tag.parse(node, value: '').content }

  it_behaves_like 'content_tag'
end
