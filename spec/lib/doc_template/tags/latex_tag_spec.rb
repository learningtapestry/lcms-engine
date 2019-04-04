# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tags::LatexTag do
  let(:img) { %(<img class="o-ld-latex" src="url">) }
  let(:node) do
    html = Nokogiri::HTML original_content
    html.at_xpath('*//ol')
  end
  let(:options) { { value: value, preserve_color: false } }
  let(:original_content) do
    <<-HTML
      <ol class="lst-kix_q3dubtijti3v-1" start="2" style="padding:0;margin:0">
        <li
          <span style="font-size:8pt;font-family:&quot;Calibri&quot;;color:#231f20;font-weight:400">&nbsp;are
          [latex: \overleftrightarrow{CD}] intersecting lines. &nbsp;In a complete sentence, des cribe the angle
          relationship in the diagram. &nbsp;Write an equation for the angle relationship shown in the figure and
          solve for </span>
        </li>
      </ol>
    HTML
  end
  let(:svg) { '<svg>Test</svg>' }
  let(:tag) { described_class.new }
  let(:tag_data) { { latex: value } }
  let(:tag_name) { DocTemplate::Tags::LatexTag::TAG_NAME }
  let(:value) { '\overleftrightarrow{CD}' }

  before do
    allow(Lcms::Engine::EmbedEquations).to receive(:tex_to_svg).with(value, preserve_color: false).and_return(svg)
  end

  subject { tag.parse(node, options).render }

  it 'removes original tag' do
    expect(subject).to_not include("[#{tag_name}]")
  end

  it 'stores tag data' do
    expect(tag.parse(node, options).tag_data).to eq tag_data
  end

  context 'general context' do
    it 'substitutes tag with inlined SVG' do
      expect(subject).to include svg
    end
  end

  context 'gdoc context' do
    before do
      options[:context_type] = :gdoc
      allow_any_instance_of(described_class).to receive(:generate_image).and_return(img)
    end

    it 'substitutes tag with generated PNG image' do
      expect(subject).to include img
    end
  end
end
