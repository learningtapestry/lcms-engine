# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::PvTag do
  let(:node) { Nokogiri::HTML(original_content).at_xpath('*//p') }
  let(:original_content) { "<p><span>[PV: </span><span >#{pv_value}</span><span>]</span></p>" }
  let(:pv_value) { 'Millions' }
  let(:params) { { value: pv_value } }
  let(:tag) { described_class.new }

  subject { tag.parse(node, params).content }

  it 'removes tag after rendering' do
    expect(subject).to_not include('[PV:')
  end

  it 'renders corresponding template' do
    expect_any_instance_of(DocTemplate::Tags::BaseTag).to receive :parse_template
    subject
  end

  context 'when config for tag value does not exist' do
    before { allow(DocTemplate::Tags).to receive(:config).and_return({}) }

    it 'does not render template' do
      expect_any_instance_of(DocTemplate::Tags::BaseTag).to_not receive :parse_template
      subject
    end
  end
end
