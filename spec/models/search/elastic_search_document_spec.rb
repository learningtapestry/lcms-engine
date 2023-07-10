# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Search::ElasticSearchDocument do
  let(:document) { described_class.new }

  describe '.repository' do
    it 'calls class method' do
      expect(described_class).to receive(:repository)
      document.repository
    end
  end

  describe '.search' do
    let(:options) { {} }
    let(:repository) { double Lcms::Engine::Search::Repository }
    let(:term) { Faker::Lorem.word }

    before do
      allow(described_class).to receive(:repository).and_return(repository)
      allow(repository).to receive(:index_exists?).and_return(true)
      allow(repository).to receive(:search)
    end

    subject { described_class.search term, options }

    it 'fires the query' do
      expect(repository).to receive(:fts_query).with(term, options)
      subject
    end

    context 'when no index exist' do
      before { allow(repository).to receive(:index_exists?) }

      it 'returns empty array' do
        expect(subject).to eq []
      end
    end

    context 'when no term passed in' do
      let(:term) { nil }

      it 'queries all' do
        expect(repository).to receive(:all_query).with(options)
        subject
      end
    end
  end

  describe '#delete!' do
    it 'calls delete on repository' do
      expect_any_instance_of(described_class).to receive_message_chain(:repository, :delete)
      document.delete!
    end
  end

  describe '#index!' do
    it 'calls save on repository' do
      expect_any_instance_of(described_class).to receive_message_chain(:repository, :save)
      document.index!
    end
  end

  describe '#repository' do
    before { described_class.instance_variable_set :@repository, nil }

    it 'creates new repository' do
      expect(Lcms::Engine::Search::Repository).to receive(:new)
      described_class.repository
    end

    it 'caches the value' do
      described_class.repository
      expect(Lcms::Engine::Search::Repository).to_not receive(:new)
      described_class.repository
    end
  end
end
