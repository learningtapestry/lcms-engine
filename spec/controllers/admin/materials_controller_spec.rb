# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::MaterialsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#create' do
    let(:material) { create :material }
    let(:form) { instance_double('Lcms::Engine::MaterialForm', material: material, save: valid) }
    let(:link) { 'link' }
    let(:params) { { link: link, source_type: 'gdoc' } }
    let(:valid) { true }

    before { allow(Lcms::Engine::MaterialForm).to receive(:new).and_return(form) }

    subject { post :create, material_form: params }

    it 'creates MaterialForm object' do
      expect(Lcms::Engine::MaterialForm).to receive(:new).with(params)
      subject
    end

    it 'redirects to material' do
      subject
      expect(response).to redirect_to Lcms::Engine::Admin::AdminController.material_path(material)
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
          receive_message_chain(:material_parse_job, :perform_later).and_return(OpenStruct.new(job_id: 0))
        subject
      end

      it 'renders import template' do
        expect(subject).to render_template :import
      end

      context 'and when there are no documents' do
        let(:file_ids) { [] }

        it 'shows the message' do
          subject
          expect(flash[:alert]).to eq I18n.t('lcms.engine.admin.materials.create.empty_folder')
        end
      end
    end

    context 'when asynchronous import was requested' do
      let(:params) { { async: '1', link: link } }

      before { allow(controller).to receive(:bulk_import) }

      it 'calls bulk import for that particular document' do
        expect(controller).to receive(:bulk_import).with(Array.wrap(link))
        subject
      end
    end
  end

  describe '#destroy' do
    let!(:material) { create :material }

    subject { delete :destroy, id: material.id }

    it { expect { subject }.to change { Lcms::Engine::Material.count }.by(-1) }

    context 'when there was custom filter' do
      let(:query) { 'filter' }

      subject { delete :destroy, id: material.id, query: query }

      it { is_expected.to redirect_to admin_materials_path(query: query) }
    end
  end

  describe '#index' do
    subject { get :index }

    it { is_expected.to be_success }

    it { is_expected.to render_template :index }
  end

  describe '#new' do
    subject { get :new }

    it 'initiates the form object' do
      expect(Lcms::Engine::MaterialForm).to receive(:new)
      subject
    end

    it { is_expected.to render_template :new }
  end
end
