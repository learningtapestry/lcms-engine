# frozen_string_literal: true

require 'rails_helper'

# TODO: Move spec to `lt-lcms` gem
# xdescribe DocumentDownloader::Gdoc do
#   let(:credentials) { double }
#   let(:downloader) { described_class.new credentials, file_url }
#   let(:file_id) { '16sDahoxlTIoGwp8SrtrGDao98GQuZMQnoc-7PKOUxUM' }
#   let(:file_url) { "https://docs.google.com/document/d/#{file_id}/edit" }
#   let(:service) { double }
#   # let(:target_class) { Document }
#
#   before do
#     allow_any_instance_of(described_class).to receive(:service).and_return(service)
#     allow_any_instance_of(described_class).to receive(:handle_google_drawings).with(content).and_return(content)
#   end
#
#   describe '#download' do
#     let(:content) { 'content' }
#
#     before do
#       allow(service).to receive(:export_file).with(file_id, any_args).and_return(service)
#       allow(service).to receive_message_chain(:encode, :force_encoding).and_return(content)
#     end
#
#     subject { downloader.download }
#
#     it 'exports file from Google Drive' do
#       subject
#       expect(downloader.content).to eq content
#     end
#
#     it 'returns self' do
#       expect(subject).to be_a described_class
#     end
#   end
# end
