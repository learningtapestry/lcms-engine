# frozen_string_literal: true

require 'rails_helper'

xdescribe Lcms::Engine::EnhanceInstructionController do
  before { sign_in create(:user) }

  describe '#index' do
    before { get :index }

    it { expect(response).to be_success }
    it { expect(response).to render_template(:index) }
    it { expect(assigns(:props)).to be_present }
  end
end
