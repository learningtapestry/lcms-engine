# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'searchable' do # rubocop:disable Metrics/BlockLength
  let(:doc) { double Search::Document }
  let(:object) { create factory }
  let(:repo) { double Search::Repository }

  before do
    allow(Search::Repository).to receive(:new).and_return(repo)
    allow(described_class).to receive(:search_model).and_return(Search::Document)
    allow(Search::Document).to receive(:build_from).and_return(doc)
    allow(doc).to receive(:search)
  end

  describe '.search' do
    let(:name) { described_class.name }
    let(:options) { { model_type: name.underscore } }
    let(:term) { Faker::Lorem.word }

    subject { described_class.search term, options }

    it 'searches the model' do
      expect(Search::Document).to receive(:search).with(term, options)
      subject
    end
  end

  describe '#delete_document' do
    subject { object.send :delete_document }

    it 'deletes the document from the search repo' do
      expect(repo).to receive(:delete).with(doc)
      subject
    end
  end

  describe '#index_document' do
    subject { object.send :index_document }

    it 'saves the document into the search repo' do
      expect(repo).to receive(:save).with(doc)
      subject
    end
  end
end
