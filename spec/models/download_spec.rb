# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Download do
  it 'has valid factory' do
    expect(build :download).to be_valid
  end

  context 'cannot be created without' do
    it 'title' do
      obj = build :download, title: nil
      expect(obj).to_not be_valid
    end

    context 'when no file passed in' do
      it 'url' do
        obj = build :download, url: nil
        expect(obj).to_not be_valid
      end
    end

    context 'when no url passed in' do
      it 'file' do
        obj = build :download, url: nil
        expect(obj).to_not be_valid
      end
    end
  end

  describe '#attachment_content_type' do
    let(:content_type) { 'type' }
    let(:download) { create :download, content_type: content_type }

    subject { download.attachment_content_type }

    it 'returns predefined content type' do
      Lcms::Engine::Download::CONTENT_TYPES.each do |type, types|
        download.update content_type: Array.wrap(types).first
        expect(download.attachment_content_type).to eq type
      end
    end

    context 'when there is no predefined content type' do
      it 'return original one' do
        expect(subject).to eq content_type
      end
    end
  end

  describe '#attachment_url' do
    let(:download) { create :download, url: "#{prefix}url/path" }
    let(:prefix) { Lcms::Engine::Download::URL_PUBLIC_PREFIX }

    subject { download.attachment_url }

    it 'subs specific public prefix' do
      expect(subject).to_not include prefix
    end

    context 'when url is absent' do
      let(:download) { build :download, file: file, url: nil }
      let(:file) { double }
      let(:url) { Faker::Internet.url }

      before do
        allow(download).to receive(:file).and_return(file)
        allow(file).to receive(:url).and_return(url)
      end

      it 'returns url of the file' do
        expect(subject).to eq url
      end
    end
  end

  describe '#s3_filename' do
    let(:download) { create :download, url: url }
    let(:url) { Faker::Internet.url }

    it 'returns base name of the attachment url' do
      expect(download.s3_filename).to eq File.basename(url)
    end
  end

  describe '#update_metadata' do
    let(:content_type) { 'type' }
    let(:download) { create :download }
    let(:file) { double }
    let(:size) { rand(10) }

    before do
      allow(download).to receive(:file).and_return(file)
      allow(file).to receive(:present?).and_return(true)
      allow(file).to receive_message_chain(:file, :content_type).and_return(content_type)
      allow(file).to receive_message_chain(:file, :size).and_return(size)
    end

    subject { download.send :update_metadata }

    it 'copies its content type' do
      expect(download).to receive(:content_type=).with(content_type)
      subject
    end

    it 'copies its size' do
      expect(download).to receive(:filesize=).with(size)
      subject
    end
  end
end
