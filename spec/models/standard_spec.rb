# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Standard do
  it 'has valid factory' do
    obj = create :standard
    expect(obj).to be_valid
  end

  describe '.search_by_name' do
    let(:alt_name) { 'a-synonym' }
    let(:name) { 'test-std' }
    let(:standard_1) { create :standard, alt_names: [alt_name.upcase], grades: ['grade 10'], subject: 'ela' }
    let(:standard_2) { create :standard, alt_names: %w(fake), grades: ['grade 10'], name: name.upcase, subject: 'ela' }

    it { expect(described_class.search_by_name('qwerty').first).to be_nil }

    it 'searches by alt_name' do
      standard_1
      expect(described_class.search_by_name(alt_name).first).to eq standard_1
    end

    it 'searches by name' do
      standard_2
      expect(described_class.search_by_name(name).first).to eq standard_2
    end
  end
end
