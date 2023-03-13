# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::DocumentForm do
  let(:credentials) { double }
  let(:form) { described_class.new params }

  before { allow_any_instance_of(described_class).to receive(:google_credentials).and_return(credentials) }

  describe '#save' do
    let(:document) { create :document }
    let(:service) { instance_double('DocumentBuildService', build_for: document, errors: []) }

    subject { form.save }

    context 'when is valid' do
      let(:link) { 'doc-url' }
      let(:params) { { link: } }

      before do
        allow(Lcms::Engine::DocumentGenerator).to receive(:generate_for)
        allow(Lcms::Engine::DocumentBuildService).to receive(:new).and_return(service)
      end

      it 'creates DocumentBuildService object' do
        expect(Lcms::Engine::DocumentBuildService).to receive(:new).with(credentials, import_retry: nil)
                                                        .and_return(service)
        subject
      end

      it 'builds the document' do
        subject
        expect(form.document).to eq document
      end

      it 'queues job to generate PDF and GDoc' do
        expect(Lcms::Engine::DocumentGenerator).to receive(:generate_for).with(document)
        subject
      end

      it 'marks the document as reimported' do
        document.update reimported: false
        subject
        expect(document.reload.reimported).to be_truthy
      end

      context 'when save operation failed' do
        before { allow(Lcms::Engine::DocumentGenerator).to receive(:generate_for).and_raise(StandardError) }

        it 'marks the document as not reimported' do
          expect(document.reload.reimported).to be_truthy
          subject
          expect(document.reload.reimported).to be_falsey
        end
      end

      context 'when that is re-import operation' do
        before { params.merge!(link_fs: 'ink_fs', reimport: '1') }

        it 'calls service sequentently to import both type of links' do
          expect(service).to receive(:build_for).with(params[:link])
          expect(service).to receive(:build_for).with(params[:link_fs], expand: true)
          subject
        end
      end

      context 'when there are non-critical errors' do
        let(:errors) { %w(error-1 error-2 error-3) }
        let(:service) { instance_double('DocumentBuildService', build_for: document, errors:) }

        it 'store service errors' do
          subject
          expect(form.service_errors).to eq errors
        end
      end
    end

    context 'when is invalid' do
      let(:params) { {} }

      it { is_expected.to be_falsey }
    end
  end
end
