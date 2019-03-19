# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::EmbedEquations do
  let(:chart_url) { 'https://chart.googleapis.com/chart?cht=tx&chf=bg,s,FFFFFF00&chco=000000&chl=EF%E2%83%A1' }
  let(:content) do
    <<-HTML
      <span>Intersecting lines</span>
      <img src="#{chart_url}">
    HTML
  end
  let(:content_new) do
    <<-HTML
      <span>Intersecting lines</span>
      #{tex_to_html}
    HTML
  end
  let(:redis) { instance_double Redis }
  let(:tex) { 'EF⃡' }
  let(:tex_to_html) { '<span>LaTeX equation</span>' }
  let(:tex_to_svg) { '<svg>LaTeX equation</svg>' }

  before { allow(described_class).to receive(:redis).and_return(redis) }

  describe '.call' do
    subject { described_class.call content }

    before { allow(redis).to receive(:get).and_return(tex_to_html) }

    it 'fetches tex from initial query' do
      expect(described_class).to receive(:fetch_tex).with(chart_url).and_return(tex)
      subject
    end

    it 'converts it to HTML' do
      allow(described_class).to receive(:fetch_tex).and_return(tex)
      expect(described_class).to receive(:tex_to_html).with(tex).and_return(tex_to_html)
      subject
    end

    it 'returns HTML with replaced image' do
      expect(subject).to eq content_new
    end
  end

  describe '.tex_to_html' do
    before { allow(redis).to receive(:get).and_return(tex_to_html) }

    subject { described_class.tex_to_html tex }

    it 'returns HTML' do
      expect(subject).to eq tex_to_html
    end

    context 'when tex is nil' do
      let(:tex) { '' }
      it { is_expected.to be_nil }
    end

    context 'when there is no previously generated HTML in Redis' do
      before do
        allow(redis).to receive(:get)
        allow(described_class).to receive(:`).and_return(tex_to_html)
        allow(redis).to receive(:set)
      end

      it 'generates HTML' do
        expect(described_class).to receive(:`).with("tex2html -- '#{tex}'")
        subject
      end

      it 'stores generated HTML into the Redis' do
        redis_key = "#{described_class::REDIS_KEY}#{tex}"
        expect(redis).to receive(:set).with(redis_key, tex_to_html)
        subject
      end
    end
  end

  describe '.tex_to_svg' do
    let(:preserve_color) { false }

    before { allow(redis).to receive(:get).and_return(tex_to_svg) }

    subject { described_class.tex_to_svg tex }

    it 'returns SVG' do
      expect(subject).to eq tex_to_svg
    end

    context 'when tex is nil' do
      let(:tex) { '' }
      it { is_expected.to be_nil }
    end

    context 'when there is no previously generated SVG in Redis' do
      before do
        allow(redis).to receive(:get)
        allow(described_class).to receive(:`).and_return(tex_to_svg)
        allow(redis).to receive(:set)
      end

      it 'generates SVG' do
        expect(described_class).to receive(:`).with("tex2svg -- '#{tex}'")
        subject
      end

      it 'stores generated SVG into the Redis' do
        redis_key = "#{described_class::REDIS_KEY_SVG}#{tex}#{preserve_color}"
        expect(redis).to receive(:set).with(redis_key, tex_to_svg)
        subject
      end
    end
  end
end
