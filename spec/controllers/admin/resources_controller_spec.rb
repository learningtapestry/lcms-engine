# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::ResourcesController do
  let(:resource) { create :resource }
  let(:user) { create :admin }

  before { sign_in user }

  describe '#edit' do
    subject { get :edit, params: { id: resource.to_param } }

    it { is_expected.to be_successful }
  end

  describe '#index' do
    subject { get :index }

    it { is_expected.to be_successful }
  end

  describe '#update' do
    let(:description) { Faker::Lorem.sentence }
    let(:params) { { description: description, directory: resource.metadata.keys.join(',') } }

    subject { post :update, params: { id: resource.to_param, resource: params } }

    context 'with valid params' do
      it { is_expected.to redirect_to lcms_engine(admin_resources_path) }

      it 'passes notice' do
        subject
        expect(flash[:notice]).to be_present
      end
    end

    context 'with overridden parameters' do
      let(:extra_param_array) { { extra_array: Faker::Lorem.words } }
      let(:extra_param_simple) { { extra_simple: Faker::Lorem.word } }

      subject do
        post :update, params: { id: resource.to_param,
                                resource: params.merge(**extra_param_simple, **extra_param_array) }
      end

      before do
        Lcms::Engine::Resource.class_eval do
          attr_accessor :extra_array
          attr_accessor :extra_simple
        end

        allow_any_instance_of(Lcms::Engine::Admin::ResourcesController).to \
          receive(:form_params_arrays_override).and_return(extra_param_array.keys[0] => [])

        allow_any_instance_of(Lcms::Engine::Admin::ResourcesController).to \
          receive(:form_params_simple_override).and_return(extra_param_simple.keys)
      end

      it 'accepts overridden parameters' do
        expect { subject }.to_not raise_error
      end

      after do
        Lcms::Engine::Resource.class_eval do
          delete :extra_array
          delete :extra_simple
        end
      end
    end
  end
end
