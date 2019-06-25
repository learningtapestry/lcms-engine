# frozen_string_literal: true

require 'rails_helper'

xdescribe Lcms::Engine::ResourcesController do
  let(:resource) { create(:resource) }

  before { sign_in create(:user) }

  describe '#pdf_proxy' do
    let(:data) { 'data' }
    let(:filename) { 'filename' }
    let(:params) { { disposition: :inline, file_name: filename } }
    let(:url) { "http://host/dir/#{filename}" }

    before { allow(URI).to receive_message_chain(:parse, :open, :read).and_return(data) }

    subject { get :pdf_proxy, url: url }

    it 'proxies the request' do
      expect(controller).to receive(:send_data).with(data, params) do
        controller.render nothing: true
      end
      subject
    end

    context 'when any error occurs' do
      before { allow(URI).to receive_message_chain(:parse, :open) }

      it { is_expected.to have_http_status 400 }
    end

    context 'when url has not been passed' do
      let(:url) { nil }

      it { is_expected.to have_http_status 404 }
    end
  end

  describe '#show' do
    context 'with slug' do
      before { get :show, slug: resource.slug }

      it { expect(response).to be_successful }
      it { expect(assigns(:resource)).to be_present }
      it { expect(assigns(:props)).to_not be_nil }
    end

    context 'with id' do
      before { get :show, id: resource.id }

      it { expect(response).to redirect_to("/#{resource.slug}") }
    end

    context 'grade' do
      let(:resource) { create(:resource, :grade) }
      before { get :show, slug: resource.slug }
      it { expect(response).to redirect_to explore_curriculum_index_path(p: resource.slug, e: 1) }
    end

    context 'module' do
      let(:resource) { create(:resource, :module) }
      before { get :show, slug: resource.slug }
      it { expect(response).to redirect_to explore_curriculum_index_path(p: resource.slug, e: 1) }
    end
  end
end
