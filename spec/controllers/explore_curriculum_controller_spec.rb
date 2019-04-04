# frozen_string_literal: true

require 'rails_helper'

xdescribe Lcms::Engine::ExploreCurriculumController do
  before { sign_in create(:user) }

  describe '#index' do
    before do
      build_resources_chain ['ela', 'grade 2', 'module 1', 'unit 1', 'lesson 10']
    end

    context 'default' do
      before { get :index }

      it { expect(response).to be_success }
      it { expect(response).to render_template(:index) }
      it { expect(assigns(:props)).to be_present }
    end

    context 'expanded' do
      before { get :index, p: '/ela/grade-2/module-1', e: '1' }

      it { expect(response).to be_success }
      it { expect(response).to render_template(:index) }
      it { expect(assigns(:props)).to be_present }
    end
  end
end
