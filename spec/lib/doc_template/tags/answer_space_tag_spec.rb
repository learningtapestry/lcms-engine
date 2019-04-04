# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::AnswerSpaceTag do
  let(:original_content) do
    <<-HTML
      <p><span>Some Question</span><br /><span>[answer-space:s]</span></p>
    HTML
  end
  let(:tag) { described_class.new }

  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//p')
  end

  subject { tag.parse(node, value: 's').content }

  it 'removes original node' do
    expect(subject).to_not include('[answer-space:s]')
  end

  it 'adds spaces for answer' do
    expect(subject).to include('<br><br><br><br><br>')
  end
end
