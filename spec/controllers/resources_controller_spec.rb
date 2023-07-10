# frozen_string_literal: true

require 'rails_helper'

xdescribe Lcms::Engine::ResourcesController do
  let(:resource) { create(:resource) }

  before { sign_in create(:user) }

  describe '#show' do
    context 'with slug' do
      before { get :show, slug: resource.slug }

      it { expect(response).to be_successful }
      it { expect(assigns(:resource)).to be_present }
      it { expect(assigns(:props)).to_not be_nil }
    end

    context 'with id' do
      before { get :show, id: resource.id }

      it { expect(response).to redirect_to("/lcms-engine#{resource.slug}") }
    end
  end
end
