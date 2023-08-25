# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Naming/VariableNumber
shared_examples_for 'navigable' do
  let(:another_grandchild) { create factory }
  let(:child) { create factory }
  let(:child_sibling) { create factory }
  let(:grandchild) { create factory }
  let(:grandchild_sibling) { create factory }
  let(:grandchild_sibling_2) { create factory }
  let(:parent) { create factory }

  before(:all) do
    described_class.destroy_all
  end

  before do
    child.children << grandchild
    child.children << grandchild_sibling
    child.children << grandchild_sibling_2
    parent.children << child

    child_sibling.children << another_grandchild
    parent.children << child_sibling
  end

  describe '#parents' do
    it 'returns ancestors in reverse order' do
      expect(grandchild.parents).to eq [parent, child]
    end
  end

  describe '#previous' do
    xit 'returns previous sabling with lower level position' do
      expect(grandchild_sibling_2.previous).to eq grandchild_sibling
    end

    context 'when it is the first sibling' do
      it 'returns last element of previous node from parent level' do
        expect(another_grandchild.previous).to eq grandchild_sibling_2
      end
    end

    context 'when level position is nil' do
      before { child.update level_position: nil }

      it 'returns nil' do
        expect(child.previous).to be_nil
      end
    end
  end

  describe '#next' do
    it 'returns next sibling with higher level position' do
      expect(grandchild_sibling.next).to eq grandchild_sibling_2
    end

    context 'when it is the last sibling' do
      it 'returns first child of the next parent' do
        expect(grandchild_sibling_2.next).to eq another_grandchild
      end
    end

    context 'when level position is nil' do
      before { child.update level_position: nil }

      it 'returns nil' do
        expect(child.next).to be_nil
      end
    end
  end
end
# rubocop:enable Naming/VariableNumber

describe Lcms::Engine::Resource do
  it 'has valid factory' do
    expect(build :resource).to be_valid
  end

  it_behaves_like 'navigable' do
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

      res = Lcms::Engine::Resource.create! parent:,
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
