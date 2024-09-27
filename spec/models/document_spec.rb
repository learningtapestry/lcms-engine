# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Document do
  let(:document) { build :document, metadata:, resource: }
  let(:doc_subject) { 'ela' }
  let(:doc_type) { 'core' }
  let(:metadata) do
    {
      subject: doc_subject,
      type: doc_type
    }
  end
  let(:resource) { build :resource }

  it 'has valid factory' do
    object = create(:document)
    expect(object).to be_valid
  end

  it { expect(document).to have_and_belong_to_many(:materials) }

  describe '#assessment?' do
    subject { document.assessment? }

    it 'proxies the call to resource' do
      expect(document.resource).to receive(:assessment?)
      subject
    end
  end

  describe '#ela?' do
    subject { document.ela? }

    it 'returns true when metadata is ELA' do
      expect(subject).to be_truthy
    end
  end

  describe '#ela?' do
    let(:doc_subject) { 'math' }

    subject { document.math? }

    it 'returns true when metadata is MATH' do
      expect(subject).to be_truthy
    end
  end

  describe '#layout' do
    let(:parts) { double }
    let(:type) { :default }

    before do
      allow(document).to receive(:document_parts).and_return(parts)
      allow(parts).to receive(:last)
    end

    subject { document.layout type }

    it 'returns the layout for the type specified' do
      params = {
        part_type: :layout,
        context_type: Lcms::Engine::DocumentPart.context_types[type]
      }
      expect(parts).to receive(:where).with(params).and_return(parts)
      subject
    end
  end

  describe '#ordered_material_ids?' do
    subject { document.ordered_material_ids }

    it 'proxies the call to the TOC' do
      expect_any_instance_of(DocTemplate::Objects::TocMetadata).to receive(:ordered_material_ids)
      subject
    end
  end

  describe '#tmp_link' do
    let(:document) { create :document }
    let(:key) { 'key' }
    let(:link) { 'link' }
    let(:links) { { key => link } }

    before { document.update links: }

    subject { document.tmp_link key }

    it 'returns the link' do
      expect(subject).to eq link
    end

    it 'removes it from the links list' do
      subject
      expect(document.links).to be_empty
    end
  end

  context 'File IDs' do
    let(:document) { build :document, file_id: }
    let(:file_id) { 'file_id' }

    describe '#file_url' do
      subject { document.file_url }
      it { is_expected.to eq "#{Lcms::Engine::Document::GOOGLE_URL_PREFIX}/#{file_id}" }
    end
  end

  context 'when is destroyed' do
    let!(:active_document) { create :document, resource: }
    let!(:another_document) { create :document, resource:, active: false }
    let!(:one_more_document) { create :document, resource:, active: false }
    let(:resource) { create :resource }

    context 'when the document is the active one' do
      it 'destroys connected resource' do
        expect(resource.document_ids.count).to eq 3
        expect(active_document.active?).to be_truthy
        expect(another_document.active?).to be_falsey
        expect(one_more_document.active?).to be_falsey

        active_document.destroy
        expect(resource.destroyed?).to be_truthy

        expect(Lcms::Engine::Document.count).to be_zero
        expect(Lcms::Engine::Resource.count).to be_zero
      end
    end

    context 'when document is not active' do
      it 'deletes itself but not the other documents and connected resource' do
        expect(resource.document_ids.count).to eq 3
        expect(active_document.active?).to be_truthy
        expect(another_document.active?).to be_falsey
        expect(one_more_document.active?).to be_falsey

        another_document.destroy

        expect(resource.reload.destroyed?).to be_falsey
        expect(resource.reload.document_ids.count).to eq 2
      end
    end
  end
end
