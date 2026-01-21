# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::DocumentBuildService do
  let(:credentials) { double }

  describe '#build_for' do
    let!(:document) { create :document, file_id: }
    let(:downloader) { double }
    let(:downloaded_document) { 'html-here' }
    let(:file) do
      double('file', name: 'file name', modified_time: Time.current - 1.day, last_modifying_user: 'User', version: '42')
    end
    let(:file_id) { 'Google Document file id' }
    let(:parsed_document) do
      double('parsed_document', activity_metadata: [{ 'material_ids' => [] }], agenda: [], parts: [])
    end
    let(:template) do
      stubs = {
        css_styles: '',
        documents: {},
        metadata: {},
        metadata_service: double('service', errors: []),
        parse: parsed_document,
        parts: [],
        render: '',
        toc: double('toc', collect_material_ids: [])
      }
      instance_double DocTemplate::Template, stubs
    end
    let(:service) { described_class.new credentials }
    let(:url) { 'doc-url' }

    subject { service.build_for url }

    before do
      allow(Lt::Lcms::Lesson::Downloader::Gdoc).to receive(:new).with(credentials, url, {}).and_return(downloader)

      # NOTE: Think about wrapping all this into instance_double
      allow(downloader).to receive(:download).and_return(downloader)
      allow(downloader).to receive(:content).and_return(downloaded_document)
      allow(downloader).to receive(:file_id).and_return(file_id)
      allow(downloader).to receive(:file).and_return(file)

      allow(DocTemplate::Template).to receive(:parse).and_return(template)
    end

    it 'downloads the document' do
      expect(downloader).to receive(:download)
      subject
    end

    it 'parses the document' do
      expect(DocTemplate::Template).to receive(:parse)
      subject
    end

    it 'updates document' do
      subject
      expect(document.reload.reimported_at).to_not be_nil
    end

    it 'sends ActiveSupport notification' do
      allow(ActiveSupport::Notifications).to receive(:instrument)
      subject
      expect(ActiveSupport::Notifications).to \
        have_received(:instrument).with(Lcms::Engine::DocumentBuildService::EVENT_BUILT, id: document.id)
    end

    it 'activates the document' do
      subject
      expect(document.reload.active).to be_truthy
    end
  end
end
