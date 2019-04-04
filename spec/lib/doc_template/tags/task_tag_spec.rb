# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::TaskTag do
  let(:node) { Nokogiri::HTML(original_content).at_xpath('*//p') }
  let(:original_content) { "<p><span>[task: #{task_number}]</span></p><p><span>" }
  let(:tag) { described_class.new }
  let(:task_number) { 2 }

  subject { tag.parse(node, value: task_number).content }

  it 'substitutes the tag' do
    expect(subject).to_not include '[task: '
    expect(subject).to include "<h4>Task #{task_number}</h4>"
  end
end
