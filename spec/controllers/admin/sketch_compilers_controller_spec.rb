# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::SketchCompilersController do
  let(:admin) { create(:admin) }

  before { sign_in admin }

  describe '#compile' do
    let(:params) { { url:, version: } }
    let(:url) { 'url' }
    let(:version) { 'v1' }

    subject { post :compile, params: }

    context 'with valid params' do
      let(:api_response) { double }
      let(:compiler) { instance_double(Lcms::Engine::SketchCompiler, compile: api_response) }
      let(:ip) { '0.0.0.0' }

      before do
        allow(Lcms::Engine::SketchCompiler).to receive_message_chain(:new, :compile).and_return(api_response)
        allow(api_response).to receive(:success?).and_return(true)
        allow(api_response).to receive(:body).and_return({ id: '1' }.to_json)
        allow(request).to receive(:remote_ip).and_return(ip)
        request.env['HTTP_REFERER'] = 'test.com'
      end

      it 'calls SketcCompiler' do
        api_params = [admin.id, ip, version]
        compile_params = [url, nil]
        expect(Lcms::Engine::SketchCompiler).to receive(:new).with(*api_params).and_return(compiler)
        expect(compiler).to receive(:compile).with(*compile_params)
        subject
      end

      it 'redirects back with URL' do
        subject
        expect(response.response_code).to eq 302
        expect(flash['notice']).to be_present
      end

      context 'when response is fail' do
        before { allow(api_response).to receive(:success?) }

        it 'redirects back with alert' do
          subject
          expect(response.response_code).to eq 302
          expect(flash['alert']).to be_present
        end
      end
    end

    context 'with invalid params' do
      before { params.delete(:url) }

      it { is_expected.to redirect_to new_admin_sketch_compiler_path }
    end
  end

  describe '#new' do
    subject { get :new }

    # TODO: Rails upgrade - move to system spec
    xcontext 'with google credentials' do
      let(:credentials) { 'credentials' }

      before { allow(controller).to receive(:google_credentials).and_return(credentials) }

      it { is_expected.to render_template(:new) }

      it 'assigns default version' do
        subject
        expect(assigns(:version)).to eq 'v1'
      end

      context 'when version has been passed in' do
        let(:version) { 'v2' }

        before { get :new, params: { version: } }

        it 'uses passed in version' do
          expect(assigns(:version)).to eq version
        end
      end
    end

    context 'without google credentials' do
      before { allow(controller).to receive(:google_credentials) }

      it { is_expected.to have_http_status 400 }
    end
  end
end
