# frozen_string_literal: true

require 'rails_helper'

describe DocTemplate::Tables::Base do
  describe '#fetch_materials' do
    subject { described_class.new.fetch_materials(data, 'materials') }

    context 'with empty materials' do
      let(:data) { { 'materials' => '' } }

      it 'does not create material_ids' do
        subject
        expect(data['material_ids']).to be_nil
      end
    end

    context 'with existing materials' do
      let!(:material1) { create :material, identifier: 'm1-test' }
      let!(:material2) { create :material, identifier: 'm2-test' }
      let(:data)       { { 'materials' => 'M1-Test; M2-Test' } }

      it 'creates material_ids' do
        subject
        expect(data['material_ids']).to eq [material1.id, material2.id]
      end
    end

    context 'with partially existing materials' do
      let!(:material2) { create :material, identifier: 'm2-test' }
      let(:data)       { { 'materials' => 'M1-Test, M2-Test' } }

      it 'creates material_ids with existing materials' do
        subject
        expect(data['material_ids']).to eq [material2.id]
      end
    end

    context 'with non existing materials' do
      let(:data) { { 'materials' => 'M1-Test, M2-Test' } }

      it 'creates empty material_ids' do
        subject
        expect(data['material_ids']).to be_empty
      end
    end
  end
end
