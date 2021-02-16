# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Naming/VariableNumber
shared_examples_for 'navigable' do # rubocop:disable Metrics/BlockLength
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
