# frozen_string_literal: true

require 'rails_helper'

xdescribe Lcms::Engine::FindLessonsController do
  before { sign_in create(:user) }

  describe '#index' do
    context 'list' do
      let(:resource) { create(:resource, title: 'index list test') }
      let!(:serialized) { ResourceSerializer.new(resource).as_json }
      before { get :index }

      it { expect(response).to be_successful }
      it { expect(response).to render_template(:index) }
      it { expect(assigns(:props)).to be_present }
      it { expect(assigns(:props)[:results]).to include(serialized) }
    end

    context 'with filters' do
      before { resources_sample_collection }

      it 'gets all lessons if no filter is defined' do
        get(:index)
        expect(assigns(:props)[:results].count).to be(19)
      end

      it 'filter by subjects' do
        get(:index, subjects: 'ela')
        expect(assigns(:props)[:results].count).to be(8)

        get(:index, subjects: 'math')
        expect(assigns(:props)[:results].count).to be(11)
      end

      it 'filter by grades' do
        get(:index, grades: '4')
        expect(assigns(:props)[:results].count).to be(4)

        get(:index, grades: '4,7')
        expect(assigns(:props)[:results].count).to be(11)
      end

      it 'compose filters' do
        get(:index, subjects: 'ela', grades: '2,4')
        expect(assigns(:props)[:results].count).to be(2)
      end
    end
  end
end
