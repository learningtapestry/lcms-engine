# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Breadcrumbs do
  let(:breadcrumbs) { described_class.new(resource) }
  let(:metadata) { Lcms::Engine::Resource.metadata_from_dir(dir) }
  let(:resource) { create :resource, curriculum_type: type, metadata: metadata }

  context 'map' do
    let(:type) { 'map' }

    context 'ela' do
      let(:dir) { ['ela'] }

      it { expect(breadcrumbs.title).to eq 'ELA' }
      it { expect(breadcrumbs.short_title).to eq 'EL' }
    end
    context 'math' do
      let(:dir) { ['math'] }

      it { expect(breadcrumbs.title).to eq 'Math' }
      it { expect(breadcrumbs.short_title).to eq 'MA' }
    end
  end

  context 'grade' do
    let(:type) { 'grade' }

    context 'ela g2' do
      let(:dir) { ['ela', 'grade 2'] }

      it { expect(breadcrumbs.title).to eq 'ELA / grade 2' }
      it { expect(breadcrumbs.short_title).to eq 'EL / G2' }
    end
    context 'math pk' do
      let(:dir) { %w(math prekindergarten) }

      it { expect(breadcrumbs.title).to eq 'Math / prekindergarten' }
      it { expect(breadcrumbs.short_title).to eq 'MA / PK' }
    end
    context 'ela k' do
      let(:dir) { %w(ela kindergarten) }

      it { expect(breadcrumbs.title).to eq 'ELA / kindergarten' }
      it { expect(breadcrumbs.short_title).to eq 'EL / K' }
    end
  end

  context 'module' do
    let(:type) { 'module' }

    context 'ela g2 m1' do
      let(:dir) { ['ela', 'grade 2', 'module 1'] }

      it { expect(breadcrumbs.title).to eq 'ELA / G2 / module 1' }
      it { expect(breadcrumbs.short_title).to eq 'EL / G2 / M1' }
    end
    context 'math pk m5' do
      let(:dir) { ['math', 'prekindergarten', 'module 5'] }

      it { expect(breadcrumbs.title).to eq 'Math / PK / module 5' }
      it { expect(breadcrumbs.short_title).to eq 'MA / PK / M5' }
    end
  end

  context 'unit/topic' do
    let(:type) { 'unit' }

    context 'ela g2 m1 u11' do
      let(:dir) { ['ela', 'grade 2', 'module 1', 'unit 11'] }

      it { expect(breadcrumbs.title).to eq 'ELA / G2 / M1 / unit 11' }
      it { expect(breadcrumbs.short_title).to eq 'EL / G2 / M1 / U11' }
    end
    context 'math pk m5 tA' do
      let(:dir) { ['math', 'prekindergarten', 'module 5', 'topic a'] }

      it { expect(breadcrumbs.title).to eq 'Math / PK / M5 / topic A' }
      it { expect(breadcrumbs.short_title).to eq 'MA / PK / M5 / TA' }
    end
  end

  context 'lesson/part' do
    let(:type) { 'lesson' }

    context 'ela g2 m1 u1 l9' do
      let(:dir) { ['ela', 'grade 2', 'module 1', 'unit 1', 'lesson 9'] }

      it { expect(breadcrumbs.title).to eq 'ELA / G2 / M1 / U1 / lesson 9' }
      it { expect(breadcrumbs.short_title).to eq 'EL / G2 / M1 / U1 / L9' }
    end
    context 'math pk m5 tA p2' do
      let(:dir) { ['math', 'prekindergarten', 'module 5', 'topic a', 'part 2'] }

      it { expect(breadcrumbs.title).to eq 'Math / PK / M5 / TA / part 2' }
      it { expect(breadcrumbs.short_title).to eq 'MA / PK / M5 / TA / P2' }
    end
  end
end
