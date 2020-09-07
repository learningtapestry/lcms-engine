# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::DocumentsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#create' do
    let(:document) { create :document }
    let(:form) do
      instance_double('Lcms::Engine::DocumentForm', document: document, save: valid, service_errors: [])
    end
    let(:link) { 'link' }
    let(:params) { { link: link, link_fs: 'link_fs', reimport: '1' } }
    let(:valid) { true }

    before { allow(Lcms::Engine::DocumentForm).to receive(:new).and_return(form) }

    subject { post :create, document_form: params }

    it 'creates DocumentForm object' do
      expect(Lcms::Engine::DocumentForm).to receive(:new).with(params)
      subject
    end

    it 'redirects to document' do
      subject
      expect(response).to redirect_to Lcms::Engine::Admin::AdminController.document_path(document)
    end

    context 'when there is an error' do
      let(:valid) { false }

      it { is_expected.to render_template :new }
    end

    context 'when a link to Google Documents folder passed in' do
      let(:credentials) { double }
      let(:file_ids) { ['file_id'] }
      let(:folder_id) { 'folder_id' }
      let(:link) { 'https://drive.google.com/drive/u/x/folders/fkjsdhfjkshfkjsdhf' }

      before do
        allow(controller).to receive(:google_credentials).and_return(credentials)
        allow(::Lt::Google::Api::Drive).to \
          receive(:folder_id_for).with(link).and_return(folder_id)
        allow(::Lt::Google::Api::Drive).to \
          receive_message_chain(:new, :list_file_ids_in, :map).and_return(file_ids)
      end

      it 'calls batch reimport' do
        expect(Lcms::Engine::DocumentGenerator).to \
          receive_message_chain(:document_parse_job, :perform_later).and_return(OpenStruct.new(job_id: 0))
        subject
      end

      it 'renders import template' do
        expect(subject).to render_template :import
      end

      context 'and when there are no documents' do
        let(:file_ids) { [] }

        it 'shows the message' do
          subject
          expect(flash[:alert]).to eq I18n.t('lcms.engine.admin.documents.create.empty_folder')
        end
      end
    end
  end

  describe '#destroy' do
    let!(:document) { create :document }

    subject { delete :destroy, id: document.id }

    it 'deletes the document' do
      expect { subject }.to change(Lcms::Engine::Document, :count).by(-1)
    end
  end

  describe '#new' do
    subject { get :new }

    it 'initiates the form object' do
      expect(Lcms::Engine::DocumentForm).to receive(:new)
      subject
    end

    it { is_expected.to render_template :new }
  end
end
