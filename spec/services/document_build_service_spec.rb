# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::DocumentBuildService do
  # TODO: Need to implement using old DocumentForm specs
  # subject { form.save }
  #
  # context 'when is valid' do
  #   let(:document) do
  #     stubs = {
  #       activate!: nil,
  #       foundational?: false,
  #       original_content: nil,
  #       update!: nil,
  #       document_parts: double('parts', delete_all: true)
  #     }
  #     instance_double Document, stubs
  #   end
  #   let(:downloader) { instance_double 'DocumentDownloader::Gdoc', import: document }
  #   let(:link) { 'doc-url' }
  #   let(:material_ids) { [1, 3] }
  #   let(:params) { { link: link } }
  #   let(:parsed_document) do
  #     OpenStruct.new(
  #       activity_metadata: [{ 'material_ids' => material_ids }],
  #       agenda: [],
  #       foundational_metadata: '',
  #       metadata: '',
  #       parts: []
  #     )
  #   end
  #   let(:template) do
  #     stubs = {
  #       css_styles: '',
  #       parse: parsed_document,
  #       parse_metadata: '',
  #       render: '',
  #       toc: ''
  #     }
  #     instance_double DocTemplate::Template, stubs
  #   end
  #
  #   before do
  #     allow(DocumentDownloader::Gdoc).to receive(:new).with(nil, link, Document).and_return(downloader)
  #     allow(DocTemplate::Template).to receive(:new).and_return(template)
  #     allow(DocumentGenerator).to receive(:generate_for)
  #   end
  #
  #   it 'downloads the document' do
  #     expect(downloader).to receive(:import)
  #   end
  #
  #   it 'parses the document' do
  #     expect(DocTemplate::Template).to receive(:new)
  #   end
  #
  #   it 'activates the document' do
  #     expect(document).to receive(:activate!)
  #   end
  #
  #   it 'queues job to generate PDF and GDoc' do
  #     expect(DocumentGenerator).to receive(:generate_for).with(document)
  #   end
  #
  #   after { subject }
  # end
end
