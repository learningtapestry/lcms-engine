# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Resource do
  it 'has valid factory' do
    expect(build :resource).to be_valid
  end

  it_behaves_like 'navigable' do
    let(:factory) { :resource }
  end

  it_behaves_like 'searchable' do
    let(:factory) { :resource }
  end

  describe '.tree' do
    before do
      pub = create(:curriculum, name: 'Test', slug: 'test', default: false)
      2.times { create(:resource) }
      3.times { create(:resource, curriculum: pub) }
      2.times { create(:resource, curriculum: nil) }
    end

    it 'selects only resources with a default curriculum assoc' do
      expect(Lcms::Engine::Resource.count).to eq 7
      expect(Lcms::Engine::Resource.tree.count).to eq 2
    end

    it 'selects resources by curriculum name' do
      expect(Lcms::Engine::Resource.tree('Test').count).to eq 3
    end

    it 'selects resources by curriculum slug' do
      expect(Lcms::Engine::Resource.tree('engageny').count).to eq 2
    end
  end

  describe '.where_subject' do
    before { resources_sample_collection }

    it 'select by subject' do
      expect(Lcms::Engine::Resource.where_subject('ela').count).to eq 8
    end
    it 'accepts multiple entries' do
      expect(Lcms::Engine::Resource.where_subject(%w(ela math)).count).to eq 19
    end
  end

  describe '.where_grade' do
    before { resources_sample_collection }

    it 'select by subject' do
      expect(Lcms::Engine::Resource.where_grade('grade 4').count).to eq 4
    end

    it 'accepts multiple entries' do
      expect(Lcms::Engine::Resource.where_grade(['grade 2', 'grade 7']).count).to eq 9
    end
  end

  describe 'update metadata on save' do
    let(:dir) { ['math', 'grade 2', 'module 1', 'topic a'] }

    before { build_resources_chain dir }

    it 'populate metadata on creation' do
      parent = Lcms::Engine::Resource.find_by_directory dir

      res = Lcms::Engine::Resource.create! parent: parent,
                                           title: 'Math-G2-M1-TA-Lesson 1',
                                           short_title: 'lesson 1',
                                           curriculum: Lcms::Engine::Curriculum.default,
                                           curriculum_type: 'lesson'
      meta = { 'subject' => 'math',
               'grade' => 'grade 2',
               'module' => 'module 1',
               'unit' => 'topic a',
               'lesson' => 'lesson 1' }
      expect(res.metadata).to_not be_empty
      expect(res.metadata).to eq meta
    end
  end
end
