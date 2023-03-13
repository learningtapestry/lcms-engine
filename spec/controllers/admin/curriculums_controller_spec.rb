# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::CurriculumsController do
  let(:user) { create :admin }

  before { sign_in user }

  describe '#edit' do
    subject { get :edit }

    it { is_expected.to be_successful }
  end

  describe '#children' do
    let(:id) { resource.id }
    let(:resource) { create(:resource, :module) }
    let!(:children) { create_list(:resource, 3, parent: resource) }

    subject { get :children, params: { id: } }

    it 'returns children of the requested resource' do
      JSON.parse(subject.body).each do |data|
        child = Lcms::Engine::Resource.find(data['id'])
        expect(child.parent_id).to eq id
      end
    end

    context 'when # is requested' do
      let(:id) { '#' }

      it 'returns root resources' do
        expect(JSON.parse(subject.body).first['id']).to eq resource.id
      end
    end
  end
end
