# frozen_string_literal: true

require 'rails_helper'

describe DocumentExporter::Gdoc::Base do
  let(:url) { "https://drive.google.com/open?id=#{file_id}" }

  describe '.url_for' do
    let(:file_id) { '12345' }

    subject { described_class.url_for file_id }

    it { is_expected.to eq url }
  end

  xdescribe '#export' do
    let(:content) { 'content' }
    let(:credentials) { double }
    let(:document) { double(base_filename: name) }
    let(:exporter) { described_class.new document }
    let(:file_id) { '16sDahoxlTIoGwp8SrtrGDao98GQuZMQnoc-7PKOUxUM' }
    let(:file_service) { double(file_id: nil, parent: nil) }
    let(:metadata) { instance_double 'Google::Apis::DriveV3::File' }
    let(:name) { 'name' }
    let(:service) { double }

    before do
      allow(exporter).to receive(:content).and_return(content)
      allow(exporter).to receive(:service).and_return(service)
      allow(exporter).to receive(:post_processing)
      allow(Google::DriveService).to receive(:new).and_return(file_service)
      allow(service).to receive_message_chain(:create_file, :id).and_return(file_id)
    end

    subject { exporter.export }

    it 'uses passed in name to prepare GDoc metadata' do
      params = {
        mime_type: 'application/vnd.google-apps.document',
        name: name,
        parents: [nil]
      }
      expect(Google::Apis::DriveV3::File).to receive(:new).with(params)
      subject
    end

    it 'calls Google Drive service to create a file' do
      expect(service).to receive(:create_file)
      subject
    end

    it 'returns self' do
      expect(subject).to be_an_instance_of(described_class)
    end
  end

  describe '#url' do
    let(:exporter) { described_class.new nil }
    let(:file_id) { '67890' }

    before { exporter.instance_variable_set :@id, file_id }

    subject { exporter.url }

    it 'returns url' do
      expect(described_class).to receive(:url_for).with(file_id)
      subject
    end
  end
end
