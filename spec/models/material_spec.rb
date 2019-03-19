# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Material do
  it 'has valid factory' do
    expect(create(:material)).to be_valid
  end

  let(:m_gdoc)  { create(:material, metadata: { type: 'vocabulary_chart' }) }
  let(:m_empty) { create(:material, metadata: {}) }
  let(:m_pdf)   { create(:material, metadata: { type: 'pdf' }) }

  subject { create :material }

  it { expect(subject).to have_and_belong_to_many(:documents) }

  describe 'validations' do
    it 'has a file_id' do
      material = build :material, file_id: nil
      expect(material).to_not be_valid
    end
  end

  describe '.where_metadata' do
    before { m_gdoc }

    it { expect(Lcms::Engine::Material.where_metadata(type: 'vocabulary_chart').count).to eq 1 }
  end

  describe 'source_type scopes' do
    before do
      m_gdoc
      m_empty
      m_pdf
    end

    context '.pdf' do
      it 'returns pdf material' do
        expect(Lcms::Engine::Material.pdf).to contain_exactly(m_pdf)
      end
    end

    context '.gdoc' do
      it 'returns gdoc materials' do
        expect(Lcms::Engine::Material.gdoc).to contain_exactly(m_gdoc, m_empty)
      end
    end
  end

  describe '#pdf?' do
    shared_examples 'if_pdf' do |result|
      it { expect(material.pdf?).to eq result }
    end

    context 'with empty type' do
      let(:material) { m_empty }
      include_examples 'if_pdf', false
    end

    context 'with pdf type' do
      let(:material) { m_pdf }
      include_examples 'if_pdf', true
    end

    context 'with other type' do
      let(:material) { m_gdoc }
      include_examples 'if_pdf', false
    end
  end
end
