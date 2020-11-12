# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Grades do
  subject { described_class.new(resource) }

  let(:dir) { [] }
  let(:resource) { create :resource, metadata: { grade: dir.uniq } }

  describe 'grades' do
    it 'returns GRADES constant' do
      expect(described_class.grades).to eq Lcms::Engine::Grades::GRADES
    end
  end

  describe 'gardes_abbrevs' do
    it 'returns GRADES_ABBR constant' do
      expect(described_class.grades_abbrevs).to eq Lcms::Engine::Grades::GRADES_ABBR
    end
  end

  describe 'list' do
    let(:dir) { ['grade 2'] }
    let(:search_doc) { Lcms::Engine::Search::Document.new(grade: ['kindergarten']) }

    it 'gets the grade list for resources' do
      grades = described_class.new(resource)
      expect(grades.list).to eq ['grade 2']
    end

    it 'gets the grade list for search document' do
      grades = described_class.new(search_doc)
      expect(grades.list).to eq ['kindergarten']
    end
  end

  describe 'average' do
    context 'multiple grades' do
      let(:dir) { ['grade 1', 'grade 2', 'grade 3', 'grade 4', 'grade 5'] }
      it { expect(subject.average).to eq '3' }
    end

    context 'single grade' do
      let(:dir) { ['kindergarten'] }
      it { expect(subject.average).to eq 'k' }
    end
  end

  describe 'average_number' do
    context 'multiple grades' do
      let(:dir) { ['grade 1', 'grade 2', 'grade 3', 'grade 4', 'grade 5'] }
      it { expect(subject.average_number).to eq 4 } # GRADES.index('grade 3') => 4
    end

    context 'single grade' do
      let(:dir) { ['kindergarten'] }
      it { expect(subject.average_number).to eq 1 } # GRADES.index('kindergarten') => 4
    end
  end

  describe 'grade_abbr' do
    it { expect(subject.grade_abbr 'prekindergarten').to eq 'pk' }
    it { expect(subject.grade_abbr 'kindergarten').to eq 'k' }
    it { expect(subject.grade_abbr 'grade 7').to eq '7' }
  end

  describe 'range' do
    let(:dir) { ['kindergarten', 'grade 1', 'grade 2', 'grade 2'] }

    it { expect(subject.range).to eq 'K-2' }
  end

  describe 'to_str' do
    context 'multiple grades' do
      let(:dir) do
        ['prekindergarten', 'kindergarten', 'grade 2', 'grade 4', 'grade 8',
         'grade 9', 'grade 10', 'grade 12']
      end
      it { expect(subject.to_str).to eq 'Grade PK-K, 2, 4, 8-10, 12' }
    end

    context 'single grade' do
      let(:dir) { ['prekindergarten'] }
      it { expect(subject.to_str).to eq 'Grade PK' }
    end
  end
end
