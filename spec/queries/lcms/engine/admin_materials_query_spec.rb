# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::AdminMaterialsQuery do
  describe 'filter by metadata' do
    let(:query) { { lesson: 1, name_date: true } }
    let(:scope) { double ActiveRecord::Relation }

    before do
      allow(Lcms::Engine::Material).to receive(:all).and_return(scope)
      allow(scope).to receive_message_chain(:reorder, :distinct).and_return(scope)
    end

    subject { described_class.call query }

    it 'filters by metadata using ILIKE' do
      expect(scope).to receive(:where_metadata_like).with(:lesson, 1).and_return(scope)
      expect(scope).to receive(:where_metadata_like).with(:name_date, true).and_return(scope)
      subject
    end

    context 'strict metadata fields' do
      let(:query) { { lesson: 1, grade: 'Grade 1', subject: Faker::Lorem.word } }

      it 'filters by metadata using explicit comparison' do
        expect(scope).to receive(:where_metadata_like).with(:lesson, 1).and_return(scope)
        expect(scope).to receive(:where_metadata).with(hash_including(grade: query[:grade].downcase)).and_return(scope)
        expect(scope).to receive(:where_metadata).with(query.slice(:subject)).and_return(scope)
        subject
      end

      it 'filters case-insensitive' do
        allow(scope).to receive(:where_metadata).with(query.slice(:subject)).and_return(scope)
        allow(scope).to receive(:where_metadata_like).with(:lesson, 1).and_return(scope)
        expect(scope).to receive(:where_metadata).with(hash_including(grade: query[:grade].downcase)).and_return(scope)
        subject
      end
    end
  end
end
