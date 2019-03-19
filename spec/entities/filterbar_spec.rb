# frozen_string_literal: true

require 'rails_helper'

describe Lcms::Engine::Filterbar do
  def filterbar(params)
    described_class.new(params)
  end

  describe 'grades' do
    it 'parses a string of grades' do
      f = filterbar grades: 'pk ,1, 3'
      expect(f.grades).to eq ['prekindergarten', 'grade 1', 'grade 3']
    end

    it 'parses an array of grades' do
      f = filterbar grades: %w(k 5)
      expect(f.grades).to eq ['kindergarten', 'grade 5']
    end

    it 'filter out invalid entries' do
      f = filterbar grades: %w(1 something else)
      expect(f.grades).to eq ['grade 1']
    end
  end

  describe 'subjects' do
    it 'parses a single entry' do
      f = filterbar subjects: 'ela'
      expect(f.subjects).to eq ['ela']
    end

    it 'parses multiple subjects' do
      f = filterbar subjects: %w(ela math)
      expect(f.subjects).to eq %w(ela math)
    end

    it 'filter out invalid entries' do
      f = filterbar subjects: %w(lead something else)
      expect(f.subjects).to eq ['lead']
    end
  end

  describe 'facets' do
    it 'parses a single entry' do
      f = filterbar facets: 'module,unit,multimedia,other'
      expect(f.facets).to eq %w(module unit multimedia other)
    end

    it 'filter out invalid entries' do
      f = filterbar facets: %w(lesson something else)
      expect(f.facets).to eq ['lesson']
    end
  end

  describe 'search_term' do
    it { expect(filterbar(search_term: 'shakespeare').search_term).to eq 'shakespeare' }

    it 'returns nil if the string is blank' do
      f = filterbar search_term: ''
      expect(f.search_term).to be_nil
    end
  end

  describe 'search_facets' do
    it 'expands multimedia and other facets' do
      f = filterbar facets: 'grade,multimedia,other'
      expect(f.search_facets).to eq %w(grade video podcast text_set quick_reference_guide)
    end
  end

  describe 'search_params' do
    it 'uses search_facets and change keys to search mapping correspondent' do
      f = filterbar facets: 'unit,multimedia', grades: 'k,1', subjects: 'ela'
      expect(f.search_params[:doc_type]).to eq %w(unit video podcast)
      expect(f.search_params[:grade]).to eq ['kindergarten', 'grade 1']
      expect(f.search_params[:subject]).to eq 'ela'
    end

    it 'adds pagination params' do
      f = filterbar facets: 'unit,multimedia', grades: 'k,1', subjects: 'ela'
      expect(f.search_params[:page]).to eq 1
      expect(f.search_params[:per_page]).to eq 20
    end
  end

  describe 'props' do
    it 'returns props compatible witht the filterbar react component' do
      f = filterbar facets: 'unit,multimedia', grades: 'k,1', subjects: 'ela'
      expect(f.props[:filterbar].keys).to eq %i(subjects grades facets search_term)
    end
  end
end
