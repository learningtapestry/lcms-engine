# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::OptBreakTag do
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end
  let(:stop_tag) do
    DocTemplate::Tags.const_get(DocTemplate::Tags.config[described_class::TAG_NAME.downcase]['stop_tags'][0])::TAG_NAME
  end
  let(:tag) { described_class.new }
  subject { tag.parse(node, agenda: double(add_break: true)).content }

  it_behaves_like 'content_tag'

  context 'with correct tag' do
    let(:original_content) do
      <<-HTML
        <p><span>[</span>#{described_class::TAG_NAME}]</p>
        <p>original content</p>
        <p><span>[</span>#{stop_tag}<span>]</span></p>
      HTML
    end

    it 'removes original node' do
      expect(subject).to_not include("[#{described_class::TAG_NAME}]")
    end

    it 'keeps original content' do
      expect(subject).to include('original content')
    end
  end
end
