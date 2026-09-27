# frozen_string_literal:true

require 'rails_helper'

class BaseSpecTag < DocTemplate::Tags::BaseTag
  TAG_NAME = 'image'

  def self.clean_tag_with_html_regexp
    @tag_with_html_regexp = nil
  end

  def self.clean_tag_with_html_regexp_array
    @tag_with_html_regexp_array = nil
  end
end

describe DocTemplate::Tags::BaseTag do
  describe '#include_break?' do
    let(:config) { { 'image' => { 'stop_tags' => %w(ImageTag PageBreakTag) } } }
    let(:node) { Nokogiri::HTML.fragment("<p><span>#{content}</span></p>").at_xpath('p') }

    before { allow(DocTemplate::Tags).to receive(:config).and_return(config) }

    subject { BaseSpecTag.new.include_break?(node) }

    ['[page-break]', '[Page-Break]', '[PAGE BREAK]', '[ PageBreak]', '[IMAGE: 1]'].each do |tag|
      context "when node contains #{tag}" do
        let(:content) { tag }

        it { is_expected.to be_truthy }
      end
    end

    context 'when node does not contain a stop tag' do
      let(:content) { '[section: 1]' }

      it { is_expected.to be_falsey }
    end

    context 'when there are no stop tags' do
      let(:config) { { 'image' => {} } }
      let(:content) { '[page-break]' }

      it { is_expected.to be_falsey }
    end
  end

  describe '.tag_with_html_regexp' do
    let(:content) do
      <<~HTML
        <p style='padding:0;font-size:11pt;font-family:"Arial";line-height:1.5;text-align:left'><span style='
        vertical-align:baseline;font-size:11pt;font-family:"Cabin";'>[image:OP.PT.L13.014, 50, Esta imagen
        muestra ruedas de carretas que han sido enterradas por la tierra movida por el viento durante una
        tormenta de polvo.] Los Estados Unidos tienen una historia trágica con sedimentos en movimiento por el viento
        Durante la década de 1930, gran parte de los Estados Unidos estaba pasando por una sequía.</span></p>
      HTML
    end

    before { BaseSpecTag.clean_tag_with_html_regexp }

    subject { BaseSpecTag.tag_with_html_regexp }

    it 'returns RegExp for a single match only' do
      data = subject.match(content)
      expect(data.size).to eq 1
    end

    context 'when TAG_NAME is not defined' do
      before { BaseSpecTag.send :remove_const, :TAG_NAME }
      after { BaseSpecTag.const_set(:TAG_NAME, 'image') }

      it 'raises an error' do
        expect { subject }.to raise_error(StandardError, 'TAG_NAME is not specified')
      end
    end

    describe '.tag_with_html_regexp_array' do
      before { BaseSpecTag.clean_tag_with_html_regexp_array }

      subject { BaseSpecTag.tag_with_html_regexp_array }

      let(:content) do
        <<~HTML
          <p style='padding:0;font-size:11pt;font-family:"Arial";line-height:1.5;text-align:left'><span style='
          vertical-align:baseline;font-size:11pt;font-family:"Cabin";'><span>[i</span><span
          style='font-family:"Montserrat"'>mage:OP.PT.L13.014, 50, Esta imagen muestra ruedas de carretas que han sido
          enterradas por la tierra movida por el viento durante una tormenta de polvo.] Los Estados Unidos tienen una
          historia trágica con sedimentos en movimiento por el viento Durante la década de 1930, gran parte de los
          Estados Unidos estaba pasando por una sequía.</span></span></p>
        HTML
      end

      subject { BaseSpecTag.tag_with_html_regexp_array(1) }

      it 'returns array of RegExp' do
        expect(subject).to all(be_a(Regexp))
        expect(subject.size).to eq 5
        expect(subject.detect { _1.match(content) }).not_to be_nil
      end
    end
  end
end
