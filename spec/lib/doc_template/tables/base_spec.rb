# frozen_string_literal: true

require 'rails_helper'
require 'sanitize'

describe DocTemplate::Tables::Base do
  let(:html) { "<p><span>[#{DocTemplate::Tags::DefaultTag::TAG_NAME}]</span></p>" }
  let(:html_rendered) { 'rendered tags' }

  describe '#collect_and_render_tags' do
    let(:data) { { 'field' => "[#{DocTemplate::Tags::DefaultTag::TAG_NAME}]" } }
    let(:fields) { %w(field) }
    let(:opts) { { keep_elements: %w(a i), separator: ',' } }

    subject { described_class.new.collect_and_render_tags data, fields, opts }

    it 'prepares the tag to render correctly' do
      expect(Nokogiri::HTML).to receive(:fragment).with(html).and_return(Nokogiri::HTML.fragment(html))
      expect(DocTemplate::Document).to receive_message_chain(:parse, :render).and_return(html_rendered)
      expect(::Sanitize).to receive(:fragment).with(html_rendered, elements: opts[:keep_elements]).and_return('')
      subject
    end
  end

  describe '#fetch_materials' do
    subject { described_class.new.fetch_materials(data, 'materials') }

    context 'with empty materials' do
      let(:data) { { 'materials' => '' } }

      it 'does not create material_ids' do
        subject
        expect(data['material_ids']).to be_nil
      end
    end

    context 'with existing materials' do
      let!(:material1) { create :material, identifier: 'm1-test' }
      let!(:material2) { create :material, identifier: 'm2-test' }
      let(:data)       { { 'materials' => 'M1-Test; M2-Test' } }

      it 'creates material_ids' do
        subject
        expect(data['material_ids']).to eq [material1.id, material2.id]
      end
    end

    context 'with partially existing materials' do
      let!(:material2) { create :material, identifier: 'm2-test' }
      let(:data)       { { 'materials' => 'M1-Test, M2-Test' } }

      it 'creates material_ids with existing materials' do
        subject
        expect(data['material_ids']).to eq [material2.id]
      end
    end

    context 'with non existing materials' do
      let(:data) { { 'materials' => 'M1-Test, M2-Test' } }

      it 'creates empty material_ids' do
        subject
        expect(data['material_ids']).to be_empty
      end
    end
  end

  describe '#parse_in_context' do
    let(:contexts) { DocTemplate::DEFAULTS[:context_types] }
    let(:metadata) { ::DocTemplate::Objects::BaseMetadata.new }
    let(:opts) { { explicit_render: false, metadata: metadata } }

    subject { described_class.new.parse_in_context html, opts }

    it 'calls renders the tag for each context type' do
      contexts.each do |context|
        opts[:context_type] = context
        doc = double DocTemplate::Document
        expect(DocTemplate::Document).to receive(:parse)
                                           .with(instance_of(Nokogiri::HTML::DocumentFragment), opts)
                                           .and_return(doc)
        expect(doc).to receive(:render).and_return(html_rendered)
      end
      subject
    end
  end
end
