# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::DocumentBundle do
  let(:bundle) { 'bundle.zip' }
  let(:category) { Lcms::Engine::DocumentBundle::CATEGORIES.sample }
  let(:doc_bundle) { double described_class }
  let(:resource) { create :resource }

  it 'has valid factory' do
    expect(build :document_bundle).to be_valid
  end

  context 'cannot be created without' do
    it 'category' do
      obj = build :document_bundle, category: nil
      expect(obj).to_not be_valid
    end

    it 'content type' do
      obj = build :document_bundle, content_type: nil
      expect(obj).to_not be_valid
    end
  end

  describe '.update_bundle' do
    let(:category) { Lcms::Engine::DocumentBundle::CATEGORIES.last }

    subject { described_class.update_bundle resource, category }

    it 'updates PDF format' do
      expect(described_class).to receive(:update_pdf_bundle).with(resource, category)
      subject
    end

    context 'when full category specified' do
      let(:category) { 'full' }

      it 'updates GDoc format' do
        expect(described_class).to receive(:update_gdoc_bundle).with(resource)
        subject
      end
    end
  end

  describe '.update_gdoc_bundle' do
    let(:bundler) { double Lcms::Engine::LessonsGdocBundler }

    before do
      allow(resource).to receive(:unit?).and_return(true)
      allow(Lcms::Engine::LessonsGdocBundler).to receive(:new).with(resource).and_return(bundler)
      allow(bundler).to receive(:bundle).and_return(bundle)
    end

    subject { described_class.send :update_gdoc_bundle, resource }

    it 'creates bundle with GDoc files' do
      expect(bundler).to receive(:bundle)
      subject
    end

    it 'creates a record with ZIP bundle' do
      params = {
        resource:,
        category: 'full',
        content_type: 'gdoc'
      }
      expect(described_class).to receive(:find_or_create_by).with(params).and_return(doc_bundle)
      expect(doc_bundle).to receive(:url=).with(bundle)
      expect(doc_bundle).to receive(:save!)
      subject
    end

    context 'when resource is not a unit type' do
      before { allow(resource).to receive(:unit?) }
      it 'does nothing' do
        expect(subject).to be_nil
      end
    end
  end

  describe '.update_pdf_bundle' do
    let(:bundler) { double Lcms::Engine::LessonsPdfBundler }

    before do
      allow(Lcms::Engine::LessonsPdfBundler).to receive(:new).with(resource, category).and_return(bundler)
      allow(bundler).to receive(:bundle).and_return(bundle)
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:open).and_yield('zip content')
      allow_any_instance_of(described_class).to receive(:save!)
      allow(FileUtils).to receive(:rm)
    end

    subject { described_class.send :update_pdf_bundle, resource, category }

    it 'creates ZIP bundle with PDF files' do
      expect(bundler).to receive(:bundle)
      subject
    end

    it 'creates a record with ZIP bundle' do
      params = {
        resource:,
        category:,
        content_type: 'pdf'
      }
      expect(described_class).to receive(:find_or_create_by).with(params).and_return(doc_bundle)
      expect(doc_bundle).to receive(:file=)
      expect(doc_bundle).to receive(:save!)
      subject
    end

    it 'removes temporary zip file' do
      expect(FileUtils).to receive(:rm)
      subject
    end
  end
end
