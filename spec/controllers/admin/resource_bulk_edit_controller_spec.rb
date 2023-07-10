# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Admin::ResourceBulkEditsController do
  let(:user) { create :admin }
  let(:resources) { Lcms::Engine::Resource.tree.lessons.where_grade('grade 6').sample(2) }
  let(:ids) { resources.map(&:id) }

  before do
    resources_sample_collection
    sign_in user
  end

  describe '#new' do
    subject { get :new, params: { ids: } }
    it { is_expected.to be_successful }
  end

  describe '#create' do
    it 'updates resources' do
      grades = resources.flat_map { |r| r.grades.list }
      expect(grades).to_not include('grade 11')
      post :create, params: { ids:, resource: { grades: ['grade 11'] } }
      expect(response).to redirect_to(lcms_engine(admin_resources_path))
      resources.each do |r|
        expect(r.reload.grades.list).to include('grade 11')
      end
    end
  end
end
