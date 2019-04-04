# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Objects::TOCMetadata do
  let(:empty_toc) { {} }
  let(:l2_toc) do
    {
      children: [
        {
          anchor: '1-title',
          children: [
            { anchor: '2-title', level: 2, material_ids: [1], title: 'title' },
            { anchor: '3-title', level: 2, material_ids: [2, 3], title: 'title' }
          ],
          level: 1,
          material_ids: [4, 5],
          title: 'title'
        },
        anchor: '4-title',
        children: [
          { anchor: '5-title', level: 2, material_ids: [4, 5, 6], title: 'title' },
          { anchor: '6-title', level: 2, material_ids: [6, 7], title: 'title' }
        ],
        level: 1,
        title: 'title'
      ]
    }
  end

  describe '#collect_children' do
    subject { described_class.load(toc).collect_children }

    context 'with empty toc' do
      let(:toc) { empty_toc }
      it { expect(subject).to be_empty }
    end

    context 'with l2 toc' do
      let(:toc) { l2_toc }
      it { expect(subject.length).to eq 6 }
    end
  end

  describe '#collect_material_ids' do
    subject { described_class.load(toc).collect_material_ids }

    context 'with empty toc' do
      let(:toc) { empty_toc }
      it { expect(subject).to be_empty }
    end

    context 'with l2 toc' do
      let(:toc) { l2_toc }
      it 'returns all uniq material ids' do
        expect(subject).to contain_exactly(1, 2, 3, 4, 5, 6, 7)
      end
    end
  end

  describe '#ordered_material_ids' do
    subject { described_class.load(toc).ordered_material_ids }

    context 'with empty toc' do
      let(:toc) { empty_toc }
      it { expect(subject).to be_empty }
    end

    context 'with l2 toc' do
      let(:toc) { l2_toc }
      it 'returns all material ids by order' do
        expect(subject).to eq [4, 5, 1, 2, 3, 4, 5, 6, 6, 7]
      end
    end
  end
end
