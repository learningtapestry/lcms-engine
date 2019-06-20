# frozen_string_literal: true

require 'rails_helper'

describe ::Lt::Lcms::Metadata::Context do
  shared_examples 'reordable' do |curriculum_type|
    subject { described_class.send("update_#{curriculum_type}s_level_position_for", children) }

    it "reorders #{curriculum_type}s" do
      subject
      expect(parent.reload.children.map(&:short_title)).to eq result
    end
  end

  context '.update_grades_level_position_for' do
    let(:parent) { build_or_return_resources_chain(['ela']) }
    let!(:children) do
      ['grade 11', 'grade 9', 'grade 10'].map do |grade|
        create(:resource, :grade, parent: parent, short_title: grade)
      end
    end
    let(:result) { ['grade 9', 'grade 10', 'grade 11'] }

    include_examples 'reordable', 'grade'
  end

  context '.update_modules_level_position_for' do
    let(:parent) { build_or_return_resources_chain(['ela', 'grade 1']) }
    let!(:children) do
      %w(m4 m3 m1 m2).map do |guidebook|
        create(:resource, :module, parent: parent, short_title: guidebook)
      end
    end
    let(:result) { %w(m1 m2 m3 m4) }

    include_examples 'reordable', 'module'
  end

  context '.update_units_level_position_for' do
    let(:parent) { build_or_return_resources_chain(['ela', 'grade 1', 'F1']) }
    let!(:children) do
      ['section 10', 'section 4', 'section 5'].map do |section|
        create(:resource, curriculum_type: 'unit', parent: parent, short_title: section)
      end
    end
    let(:result) { ['section 4', 'section 5', 'section 10'] }

    include_examples 'reordable', 'unit'
  end
end
